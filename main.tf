terraform {
  required_providers {
    docker = {
      source  = "kreuzwerker/docker"
      version = "3.0.2"
    }
  }
}

variable "image_name" {
  type = string
}

provider "docker" {}

resource "docker_image" "mysql" {
  name = "mysql:latest"
}

resource "docker_network" "private" {
  name   = "private"
  driver = "bridge"
}

resource "docker_container" "application" {
  image       = var.image_name
  name        = "application"
  hostname    = "application"
  working_dir = "/code"
  command     = ["./healthcheck.sh"]

  ports {
    internal = 8000
    external = 8000
  }
  volumes {
    container_path = "/code"
    volume_name    = docker_volume.app_volume.name
    read_only      = false
  }
  network_mode = "bridge"
  networks_advanced {
    name = docker_network.private.name
  }
}

resource "docker_container" "db" {
  image    = docker_image.mysql.name
  name     = "db"
  hostname = "db"
  env = [
    "MYSQL_DATABASE=app",
    "MYSQL_ROOT_PASSWORD=passw0rd",
    "TZ=Asia/Tokyo"
  ]
  ports {
    internal = 3306
    external = 3306
  }
  volumes {
    container_path = "/var/lib/mysql"
    volume_name    = docker_volume.data_volume.name
  }
  network_mode = "bridge"
  networks_advanced {
    name = docker_network.private.name
  }
}

resource "docker_volume" "app_volume" {
  name = "app-volume"
}

resource "docker_volume" "data_volume" {
  name = "data-volume"
}
