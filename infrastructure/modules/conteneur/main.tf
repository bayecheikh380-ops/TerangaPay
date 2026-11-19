resource "docker_container" "this" {
  name  = var.container_name
  image = var.image

  restart = "unless-stopped"
  env     = var.environment
  command = length(var.command) > 0 ? var.command : null

  networks_advanced {
    name = var.network_name
  }

  dynamic "volumes" {
    for_each = var.volume_name == null ? [] : [var.volume_name]

    content {
      volume_name    = volumes.value
      container_path = var.container_path
    }
  }
}
