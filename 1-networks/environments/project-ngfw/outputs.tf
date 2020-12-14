output "subnets_untrust_self_link" {
  value       = module.untrust.subnets_self_links
  description = "The self-links of subnets being created"
}

output "subnets_mgmt_self_link" {
  value       = module.management.subnets_self_links
  description = "The self-links of subnets being created"
}

output "subnets_trust_self_link" {
  value       = module.trust.subnets_self_links
  description = "The self-links of subnets being created"
}

output "untrust_network_name" {
  value       = module.untrust.network_name
  description = "The name of the VPC being created"
}

output "untrust_network_self_link" {
  value       = module.untrust.network_self_link
  description = "The URI of the VPC being created"
}

output "trust_network_name" {
  value       = module.trust.network_name
  description = "The name of the VPC being created"
}

output "trust_network_self_link" {
  value       = module.trust.network_self_link
  description = "The URI of the VPC being created"
}

output "mgmt_network_name" {
  value       = module.management.network_name
  description = "The name of the VPC being created"
}

output "mgmt_network_self_link" {
  value       = module.management.network_self_link
  description = "The URI of the VPC being created"
}