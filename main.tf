terraform {
  required_providers {
    docker = {
      source = "kreuzwerker/docker"
      version = "2.11.0"
    }
  }
}
provider "docker" {

  registry_auth {
    address = "registry.hub.docker.com"
    username = "shivani221"
    password = var.password
  }
}

resource "docker_image" "myimage" {
  name = "shivani221/tomcatserver:latest"
  build {
      path="."
  }
  force_remove = true
}

resource "docker_container" "mycontainer" {
  name  = "mytomcat"
  image = docker_image.myimage.latest
  must_run = true
  ports {
    internal = 8080
    external = 9090
  }
}

variable "password" {
  type = string
}
