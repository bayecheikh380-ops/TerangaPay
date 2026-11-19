import os
import psycopg
from flask import Flask, jsonify

app = Flask(__name__)

@app.route("/")
def accueil():
    return jsonify({
        "projet": "TerangaPay",
        "message": "Bienvenue sur l'API TerangaPay",
        "statut": "operationnel"
    })

@app.route("/health")
def health():
    return jsonify({"status": "OK"}), 200

@app.route("/db")
def verifier_db():
    try:
        with psycopg.connect(
            host=os.getenv("DB_HOST", "terangapay-postgres"),
            dbname=os.getenv("DB_NAME", "terangapay"),
            user=os.getenv("DB_USER", "teranga"),
            password=os.environ["DB_PASSWORD"],
            connect_timeout=3
        ) as conn:
            with conn.cursor() as cur:
                cur.execute("SELECT 1")
                cur.fetchone()

        return jsonify({
            "database": "connected",
            "status": "OK"
        }), 200

    except Exception:
        app.logger.exception("Echec de la connexion PostgreSQL")
        return jsonify({
            "database": "disconnected",
            "status": "ERROR"
        }), 503

if __name__ == "__main__":
    app.run(host="0.0.0.0", port=8080)
