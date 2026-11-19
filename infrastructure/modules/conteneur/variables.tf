variable "container_name" {
  description = "Nom du conteneur Docker"
  type        = string
}

variable "image" {
  description = "Image Docker utilisée"
  type        = string
}

variable "network_name" {
  description = "Réseau Docker du conteneur"
  type        = string
}

variable "environment" {
  description = "Variables d'environnement du conteneur"
  type        = list(string)
  default     = null
  nullable    = true
}

variable "command" {
  description = "Commande de démarrage du conteneur"
  type        = list(string)
  default     = []
}

variable "volume_name" {
  description = "Volume Docker facultatif"
  type        = string
  default     = null
}

variable "container_path" {
  description = "Chemin de montage du volume"
  type        = string
  default     = "/data"
}
