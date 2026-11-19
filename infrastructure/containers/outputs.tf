output "postgres_container_name" {
  description = "Nom du conteneur PostgreSQL"
  value       = module.postgres.container_name
}

output "redis_container_name" {
  description = "Nom du conteneur Redis"
  value       = module.redis.container_name
}

output "postgres_volume_name" {
  description = "Nom du volume PostgreSQL"
  value       = docker_volume.postgres_data.name
}

output "docker_network_name" {
  description = "Nom du réseau Docker utilisé"
  value       = data.docker_network.teranga_network.name
}
