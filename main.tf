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
    external = 9091
  }
}
resource "docker_network" "my_network" {
  name = "my_selenium_network"
}

resource "docker_image" "selenium" {
  name = "selenium/hub"
}
resource "docker_container" "selenium-hub" {
  name = "my_selenium-hub"
  image = docker_image.selenium.latest
  must_run = true
  ports {
    internal = 4444
    external = 4444
  }
  env = toset(["GRID_TIMEOUT=240000","GRID_BROWSER_TIMEOUT=240000"])
  networks_advanced {
	name = docker_network.my_network.name
  }
}
resource "docker_image" "chromeimg" {
  name = "selenium/node-chrome"
}
resource "docker_container" "chrome_1" {
  name  = "my_chrome_1"
  image = docker_image.chromeimg.latest
  must_run = true
  ports {
    internal = 5900
  }
  env = toset(["HUB_HOST=selenium-hub","HUB_PORT=4444","JAVA_OPTS=-Dwebdriver.chrome.whitelistedIps="])
  networks_advanced {
	name = docker_network.my_network.name
  }
}

resource "docker_container" "chrome_2" {
  name  = "my_chrome_2"
  image = docker_image.chromeimg.latest
  must_run = true
  ports {
    internal = 5900
  }
  env = toset(["HUB_HOST=selenium-hub","HUB_PORT=4444","JAVA_OPTS=-Dwebdriver.chrome.whitelistedIps="])
  networks_advanced {
	name = docker_network.my_network.name
  }
}

resource "docker_container" "chrome_3" {
  name  = "my_chrome_3"
  image = docker_image.chromeimg.latest
  must_run = true
  ports {
    internal = 5900
  }
  env = toset(["HUB_HOST=selenium-hub","HUB_PORT=4444","JAVA_OPTS=-Dwebdriver.chrome.whitelistedIps="])
  networks_advanced {
	name = docker_network.my_network.name
  }
}

variable "password" {
  type = string
}
