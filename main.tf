terraform {
  required_providers {
    google = {
      source  = "hashicorp/google"
      version = "5.13.0"
    }
    docker = {
      source  = "kreuzwerker/docker"
      version = "3.0.2"
    }
  }
}

provider "google" {
  credentials = file(var.credentials)
  project     = var.gcp_project
  region      = var.region
}

resource "google_storage_bucket" "ny_taxi_bucket" {
  name          = "${var.gcp_project}-ny-taxi-data"
  location      = var.location
  force_destroy = true


  lifecycle_rule {
    condition {
      age = 1 // in days
    }
    action {
      type = "AbortIncompleteMultipartUpload"
    }
  }
}

resource "google_bigquery_dataset" "ny_taxi_dataset" {
  dataset_id = var.bq_dataset_name
  location   = var.location
}

provider "docker" {
  host = "unix:///var/run/docker.sock"
}

# Create an image
resource "docker_image" "mage-ai" {
  name         = "mage-ai:zoomcamp"
  force_remove = true
  build {
    context    = "."
    dockerfile = "Dockerfile"
  }
}

# Create a container
resource "docker_container" "magic" {
  image    = docker_image.mage-ai.image_id
  name     = "magic"
  command  = ["mage", "start", var.project_name]
  must_run = true
  ports {
    internal = "6789"
    external = "6789"
  }
  volumes {
    host_path      = var.local_project_path
    container_path = var.mage_container_path
  }
  env = [
    "USER_CODE_PATH=${var.mage_container_path}",
    "ENV=${var.environment}",
    "GOOGLE_APPLICATION_CREDENTIALS=${var.container_path_to_credentials}"
  ]
}

