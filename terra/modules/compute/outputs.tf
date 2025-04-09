output "bastion_public_ip" {
  value       = yandex_compute_instance.bastion.network_interface.0.nat_ip_address
  description = "Bastion host public IP"
}

output "private_server_ip" {
  value       = yandex_compute_instance.private.network_interface.0.ip_address
  description = "Private server internal IP"
}