output "bastion_public_ip" {
  value       = module.compute.bastion_public_ip
  description = "Public IP address of bastion host"
}

output "private_server_ip" {
  value       = module.compute.private_server_ip
  description = "Private IP address of internal server"
}

output "database_fqdn" {
  value       = module.database.db_fqdn
  description = "Database FQDN"
}