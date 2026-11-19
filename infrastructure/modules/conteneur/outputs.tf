output "container_name" {
  description = "Nom du conteneur Docker"
  value       = docker_container.this.name
}
