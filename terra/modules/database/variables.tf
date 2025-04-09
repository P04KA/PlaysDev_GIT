variable "vpc_id" {
  description = "VPC network ID"
  type        = string
}

variable "subnet_id" {
  description = "Subnet ID"
  type        = string
}

variable "private_sg_id" {
  description = "Private security group ID"
  type        = string
}

variable "db_name" {
  description = "Database name"
  type        = string
}

variable "db_credentials" {
  description = "Database credentials"
  type = object({
    username = string
    password = string
  })
  sensitive = true
}

variable "zone" {
  description = "Availability zone"
  type        = string
}
