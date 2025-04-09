terraform {
  required_providers {
    yandex = {
      source = "yandex-cloud/yandex"
    }
  }
  required_version = ">= 0.13"
}

provider "yandex" {
  service_account_key_file     = "key.json"
  cloud_id  = "b1g5b020anchqspg6qul"
  folder_id = "b1g29785h55ampa74ipj"
  zone      = "ru-central1-d"
}
module "network" {
  source = "./modules/network"

  vpc_name           = "main-vpc"
  public_subnet_zone = "ru-central1-a"
  private_subnet_zone = "ru-central1-b"
  public_subnet_cidr  = "192.168.10.0/24"
  private_subnet_cidr = "192.168.20.0/24"
  ssh_access_rules   = var.ssh_access_rules
}

module "compute" {
  source = "./modules/compute"

  vpc_id             = module.network.vpc_id
  public_subnet_id   = module.network.public_subnet_id
  private_subnet_id  = module.network.private_subnet_id
  bastion_sg_id      = module.network.bastion_sg_id
  private_sg_id      = module.network.private_sg_id
  zone_a             = "ru-central1-a"
  zone_b             = "ru-central1-b"
}

module "database" {
  source = "./modules/database"

  vpc_id          = module.network.vpc_id
  subnet_id       = module.network.private_subnet_id
  private_sg_id   = module.network.private_sg_id  
  db_name        = "mydb"
  db_credentials = var.db_credentials
  zone           = "ru-central1-b"
}