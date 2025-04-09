terraform {
  required_providers {
    yandex = {
      source = "yandex-cloud/yandex"
    }
  }
  required_version = ">= 0.13"
}

resource "yandex_mdb_postgresql_cluster" "this" {
  name        = var.db_name
  environment = "PRESTABLE"
  network_id  = var.vpc_id


  config {
    version = 15
    resources {
      resource_preset_id = "s2.micro"
      disk_type_id       = "network-ssd"
      disk_size          = 16
    }
  }

  host {
    zone             = var.zone
    subnet_id        = var.subnet_id
    assign_public_ip = false  # Отключаем публичный IP
  }

  # Правильное расположение security_group_ids
  security_group_ids = [var.private_sg_id]
}

resource "yandex_mdb_postgresql_user" "admin" {
  cluster_id = yandex_mdb_postgresql_cluster.this.id
  name       = "admim1234"
  password   = "951753asdfGHHG"
}

resource "yandex_mdb_postgresql_database" "default" {
  cluster_id = yandex_mdb_postgresql_cluster.this.id
  name       = "default111"
  owner      = "admim1234"
}