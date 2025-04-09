variable "yandex_cloud_id" {
  type        = string
  description = "Yandex Cloud ID"
}

variable "yandex_folder_id" {
  type        = string
  description = "Yandex Folder ID"
}

variable "yandex_token" {
  type        = string
  sensitive   = true
  description = "Yandex IAM token"
}

variable "ssh_access_rules" {
  type = list(object({
    rule_name = string
    cidr      = string
  }))
  default = [{
    rule_name = "home-ip",
    cidr      = "104.28.198.245/32"
  }]
  description = "SSH access rules"
}

variable "db_credentials" {
  type = object({
    username = string
    password = string
  })
  sensitive   = true
  description = "Database credentials"
}