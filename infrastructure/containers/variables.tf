variable "postgres_password" {
  description = "Mot de passe de la base PostgreSQL"
  type        = string
  sensitive   = true
}

variable "postgres_db" {
  description = "Nom de la base de données"
  type        = string
  default     = "terangapay"

  validation {
    condition     = can(regex("^[a-zA-Z][a-zA-Z0-9_]{2,30}$", var.postgres_db))
    error_message = "Le nom de la base doit commencer par une lettre et contenir entre 3 et 31 caractères alphanumériques ou underscores."
  }
}

variable "postgres_user" {
  description = "Utilisateur PostgreSQL"
  type        = string
  default     = "teranga"

  validation {
    condition     = can(regex("^[a-zA-Z][a-zA-Z0-9_]{2,30}$", var.postgres_user))
    error_message = "Le nom utilisateur doit commencer par une lettre et contenir entre 3 et 31 caractères alphanumériques ou underscores."
  }
}

variable "postgres_image" {
  description = "Image Docker PostgreSQL"
  type        = string
  default     = "postgres:16-alpine"
}

variable "redis_image" {
  description = "Image Docker Redis"
  type        = string
  default     = "redis:7-alpine"
}

variable "network_name" {
  description = "Nom du réseau Docker existant"
  type        = string
  default     = "terangapay-network"

  validation {
    condition     = can(regex("^[a-zA-Z0-9][a-zA-Z0-9_.-]*$", var.network_name))
    error_message = "Le nom du réseau contient des caractères non autorisés."
  }
}
