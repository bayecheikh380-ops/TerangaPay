terraform {
  required_providers {
    docker = {
      source  = "kreuzwerker/docker"
      version = "~> 3.0"
    }
  }
}

provider "docker" {}

resource "docker_network" "teranga_network" {
  name   = "terangapay-network"
  driver = "bridge"
}

output "network_name" {
  description = "Nom du réseau Docker TerangaPay"
  value       = docker_network.teranga_network.name
}
