variable "vpc_id" {
  description = "VPC network ID"
  type        = string
}

variable "public_subnet_id" {
  description = "Public subnet ID"
  type        = string
}

variable "private_subnet_id" {
  description = "Private subnet ID"
  type        = string
}

variable "bastion_sg_id" {
  description = "Bastion security group ID"
  type        = string
}

variable "private_sg_id" {
  description = "Private security group ID"
  type        = string
}

variable "zone_a" {
  description = "First availability zone"
  type        = string
}

variable "zone_b" {
  description = "Second availability zone"
  type        = string
}