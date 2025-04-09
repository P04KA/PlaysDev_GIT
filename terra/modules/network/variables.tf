variable "vpc_name" {
  type        = string
  description = "VPC network name"
}

variable "public_subnet_zone" {
  type        = string
  description = "Zone for public subnet"
}

variable "private_subnet_zone" {
  type        = string
  description = "Zone for private subnet"
}

variable "public_subnet_cidr" {
  type        = string
  description = "CIDR block for public subnet"
}

variable "private_subnet_cidr" {
  type        = string
  description = "CIDR block for private subnet"
}

variable "ssh_access_rules" {
  type = list(object({
    rule_name = string
    cidr      = string
  }))
  description = "SSH access rules"
}