output "network" {
  value = module.vpc.network
}

output "subnets" {
  value = module.vpc.subnets_ids
}

output "psaccess" {
  value = module.psaccess
}
