data "docker_network" "teranga_network" {
  name = var.network_name
}

resource "docker_volume" "postgres_data" {
  name = "terangapay-postgres-data"
}

module "postgres" {
  source = "../modules/conteneur"

  container_name = "terangapay-postgres"
  image          = var.postgres_image
  network_name   = data.docker_network.teranga_network.name

  environment = [
    "POSTGRES_DB=${var.postgres_db}",
    "POSTGRES_USER=${var.postgres_user}",
    "POSTGRES_PASSWORD=${var.postgres_password}"
  ]

  volume_name    = docker_volume.postgres_data.name
  container_path = "/var/lib/postgresql/data"
}

module "redis" {
  source = "../modules/conteneur"

  container_name = "terangapay-redis"
  image          = var.redis_image
  network_name   = data.docker_network.teranga_network.name

  command = ["redis-server", "--appendonly", "yes"]
}
