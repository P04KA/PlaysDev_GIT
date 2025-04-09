output "vpc_id" {
  value       = yandex_vpc_network.this.id
  description = "VPC network ID"
}

output "public_subnet_id" {
  value       = yandex_vpc_subnet.public.id
  description = "Public subnet ID"
}

output "private_subnet_id" {
  value       = yandex_vpc_subnet.private.id
  description = "Private subnet ID"
}

output "bastion_sg_id" {
  value       = yandex_vpc_security_group.bastion.id
  description = "Bastion security group ID"
}

output "private_sg_id" {
  value       = yandex_vpc_security_group.private.id
  description = "Private security group ID"
}