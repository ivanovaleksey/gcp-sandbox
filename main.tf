terraform {
  required_providers {
    google = {
      source  = "hashicorp/google"
      version = "4.20.0"
    }
  }
}

provider "google" {
  project = "virtual-cycling-169415"
  region  = "europe-north1"
  zone    = "europe-north1-a"
}

resource "google_compute_network" "vpc_network" {
  name = "terraform-network"
}
