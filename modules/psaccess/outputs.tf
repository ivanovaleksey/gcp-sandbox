output "address" {
  value = google_compute_global_address.alloc
}

output "address_id" {
  value = google_compute_global_address.alloc.id
}

output "address_name" {
  value = google_compute_global_address.alloc.name
}

output "peering" {
  value = google_service_networking_connection.psaccess
}
