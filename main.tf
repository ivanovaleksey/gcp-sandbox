terraform {
  required_providers {
    google = {
      source  = "hashicorp/google"
      version = "4.20.0"
    }
  }
}

provider "google" {
  project = var.project
  region  = var.region
  zone    = var.zone
}

module "vpc" {
  source  = "terraform-google-modules/network/google"
  version = "~> 4.0"

  project_id   = var.project
  network_name = var.network_name
  mtu          = 1460

  subnets = [
    {
      subnet_name   = "subnet-01"
      subnet_ip     = "10.10.10.0/24"
      subnet_region = var.region
    },
    {
      subnet_name   = "subnet-02"
      subnet_ip     = "10.10.20.0/24"
      subnet_region = var.region
    }
  ]

  firewall_rules = [
    {
      name      = "allow-ssh-ingress"
      direction = "INGRESS"
      ranges    = ["0.0.0.0/0"]
      allow = [
        {
          protocol = "tcp"
          ports    = ["22"]
        }
      ]
    }
  ]
}

locals {
  network_id = module.vpc.network_id
  subnet_1   = module.vpc.subnets_ids[0]
}

module "psaccess" {
  source  = "./modules/psaccess"
  network = local.network_id
}

resource "google_memcache_instance" "instance" {
  name       = var.memcache_instance_name
  node_count = 1

  node_config {
    cpu_count      = 1
    memory_size_mb = 128
  }

  authorized_network = local.network_id

  depends_on = [module.psaccess]
}

resource "google_compute_instance" "default" {
  name         = "main"
  machine_type = "e2-micro"

  boot_disk {
    initialize_params {
      image = "debian-cloud/debian-9"
    }
  }

  network_interface {
    network    = local.network_id
    subnetwork = local.subnet_1

    access_config {
      // Include this section to give the VM an external IP address
    }
  }

  metadata_startup_script = "sudo apt-get install telnet"
}
