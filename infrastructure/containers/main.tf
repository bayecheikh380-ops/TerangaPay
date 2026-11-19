data "docker_network" "teranga_network" {
  name = "terangapay-network"
}

resource "docker_volume" "postgres_data" {
  name = "terangapay-postgres-data"
}

resource "docker_container" "postgres" {
  name  = "terangapay-postgres"
  image = "postgres:16-alpine"

  restart = "unless-stopped"

  env = [
    "POSTGRES_DB=terangapay",
    "POSTGRES_USER=teranga",
    "POSTGRES_PASSWORD=${var.postgres_password}"
  ]

  networks_advanced {
    name = data.docker_network.teranga_network.name
  }

  volumes {
    volume_name    = docker_volume.postgres_data.name
    container_path = "/var/lib/postgresql/data"
  }
}
resource "docker_container" "redis" {
  name  = "terangapay-redis"
  image = "redis:7-alpine"

  restart = "unless-stopped"

  command = ["redis-server", "--appendonly", "yes"]

  networks_advanced {
    name = data.docker_network.teranga_network.name
  }
}
