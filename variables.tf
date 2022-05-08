variable "project" {}

variable "region" {
  default = "europe-north1"
}

variable "zone" {
  default = "europe-north1-c"
}

variable "network_name" {
  default = "main-vpc"
}

variable "memcache_instance_name" {
  default = "memcached"
}
