terraform {
  required_providers {
    yandex = {
      source = "yandex-cloud/yandex"
    }
  }
  required_version = ">= 0.13"
}

resource "yandex_compute_instance" "bastion" {
  name        = "bastion-host"
  platform_id = "standard-v3"
  zone        = var.zone_a

  resources {
    cores  = 2
    memory = 2
  }

  boot_disk {
    initialize_params {
      image_id = "fd827b91d99psvq5fjit" # Ubuntu 20.04
    }
  }

  network_interface {
    subnet_id          = var.public_subnet_id
    nat                = true
    security_group_ids = [var.bastion_sg_id]
  }

  metadata = {
    ssh-keys = "ubuntu:${file("~/.ssh/id_rsa.pub")}"
  }
}

resource "yandex_compute_instance" "private" {
  name        = "private-server"
  platform_id = "standard-v3"
  zone        = var.zone_b

  resources {
    cores  = 2
    memory = 2
  }

  boot_disk {
    initialize_params {
      image_id = "fd827b91d99psvq5fjit" # Ubuntu 20.04
    }
  }

  network_interface {
    subnet_id          = var.private_subnet_id
    security_group_ids = [var.private_sg_id]
  }

  metadata = {
    ssh-keys = "ubuntu:${file("~/.ssh/id_rsa.pub")}"
  }
}