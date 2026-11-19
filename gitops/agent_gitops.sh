
#!/usr/bin/env bash

# =====================================================
# TERANGAPAY - AGENT GITOPS
# Surveillance Git et reconciliation automatique Ansible
# =====================================================

set -u

PROJECT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
GITOPS_DIR="$PROJECT_DIR/gitops"
LOG_DIR="$PROJECT_DIR/logs"

PID_FILE="$GITOPS_DIR/agent_gitops.pid"
LOG_FILE="$LOG_DIR/agent_gitops.log"

INTERVAL="${GITOPS_INTERVAL:-60}"
INVENTORY="${GITOPS_INVENTORY:-ansible/inventory-dev.ini}"
PLAYBOOK="playbooks/site.yml"

mkdir -p "$LOG_DIR"

log() {
    echo "[$(date '+%Y-%m-%d %H:%M:%S')] $*" | tee -a "$LOG_FILE"
}

get_commit() {
    git -C "$PROJECT_DIR" rev-parse HEAD 2>/dev/null || echo "inconnu"
}

run_agent() {
    log "Agent GitOps démarré."
    log "Intervalle : ${INTERVAL}s"
    log "Inventaire : $INVENTORY"

    local last_commit
    last_commit="$(get_commit)"

    while true; do
        sleep "$INTERVAL"

        log "Début du cycle de réconciliation."

        if ! git -C "$PROJECT_DIR" pull --ff-only origin main; then
            log "ERREUR : récupération Git impossible. Nouvelle tentative au prochain cycle."
            continue
        fi

        local current_commit
        current_commit="$(get_commit)"

        log "Commit actuel : $current_commit"

        if [[ "$current_commit" != "$last_commit" ]]; then
            log "Nouveau commit détecté : $current_commit"
            log "Application de la configuration avec Ansible."

            if ansible-playbook \
                -i "$PROJECT_DIR/$INVENTORY" \
                "$PROJECT_DIR/$PLAYBOOK"; then

                log "SUCCÈS : réconciliation Ansible terminée."
                last_commit="$current_commit"
            else
                log "ERREUR : Ansible a échoué. Nouvelle tentative au prochain cycle."
            fi
        else
            log "Aucun changement détecté. État déjà à jour."
        fi
    done
}

start_agent() {
    if [[ -f "$PID_FILE" ]]; then
        local old_pid
        old_pid="$(cat "$PID_FILE")"

        if kill -0 "$old_pid" 2>/dev/null; then
            echo "L'agent GitOps fonctionne déjà (PID $old_pid)."
            exit 0
        fi

        rm -f "$PID_FILE"
    fi

    nohup bash "$0" run >> "$LOG_FILE" 2>&1 &
    echo "$!" > "$PID_FILE"

    echo "Agent GitOps démarré."
    echo "PID : $(cat "$PID_FILE")"
    echo "Journal : $LOG_FILE"
}

stop_agent() {
    if [[ ! -f "$PID_FILE" ]]; then
        echo "Aucun agent GitOps actif."
        exit 0
    fi

    local pid
    pid="$(cat "$PID_FILE")"

    if kill -0 "$pid" 2>/dev/null; then
        kill "$pid"
        echo "Arrêt demandé pour l'agent GitOps (PID $pid)."
    else
        echo "Agent déjà arrêté."
    fi

    rm -f "$PID_FILE"
}

case "${1:-}" in
    start)
        start_agent
        ;;
    stop)
        stop_agent
        ;;
    run)
        run_agent
        ;;
    status)
        if [[ -f "$PID_FILE" ]] && kill -0 "$(cat "$PID_FILE")" 2>/dev/null; then
            echo "Agent actif (PID $(cat "$PID_FILE"))."
        else
            echo "Agent arrêté."
        fi
        ;;
    *)
        echo "Utilisation : $0 {start|stop|status|run}"
        exit 1
        ;;
esac
