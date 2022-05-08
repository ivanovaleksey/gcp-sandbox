resource "random_id" "random_suffix" {
  byte_length = 4
}

locals {
  random_suffix = random_id.random_suffix.hex
}

resource "google_compute_global_address" "alloc" {
  name          = "alloc-${local.random_suffix}"
  purpose       = "VPC_PEERING"
  address_type  = "INTERNAL"
  network       = var.network
  prefix_length = 24
}

resource "google_service_networking_connection" "psaccess" {
  network                 = var.network
  service                 = "servicenetworking.googleapis.com"
  reserved_peering_ranges = [google_compute_global_address.alloc.name]
}
