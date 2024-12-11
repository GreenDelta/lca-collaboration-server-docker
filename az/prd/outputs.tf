output "fqdn" {
  description = "FQDN of the LCA Collaboration Server"
  value       = module.gateway.fqdn
}

output "elasticsearch_vm_private_ip" {
  value       = var.elasticsearch_admin_user != "" ? module.elasticsearch[0].private_ip : null
  description = "Private IP address of the Elasticsearch VM for internal network access."
  sensitive   = true
}

output "elasticsearch_vm_public_ip" {
  value       = var.elasticsearch_admin_user != "" ? module.elasticsearch[0].public_ip : null
  description = "Public IP address of the Elasticsearch VM"
  sensitive   = true
}
