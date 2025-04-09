terraform {
  required_providers {
    yandex = {
      source = "yandex-cloud/yandex"
    }
  }
  required_version = ">= 0.13"
}
resource "yandex_vpc_network" "this" {
  name = var.vpc_name
}

resource "yandex_vpc_subnet" "public" {
  name           = "public-subnet"
  zone           = var.public_subnet_zone
  network_id     = yandex_vpc_network.this.id
  v4_cidr_blocks = [var.public_subnet_cidr]
}

resource "yandex_vpc_subnet" "private" {
  name           = "private-subnet"
  zone           = var.private_subnet_zone
  network_id     = yandex_vpc_network.this.id
  v4_cidr_blocks = [var.private_subnet_cidr]
}

resource "yandex_vpc_security_group" "bastion" {
  name        = "bastion-sg"
  network_id  = yandex_vpc_network.this.id

  dynamic "ingress" {
    for_each = var.ssh_access_rules
    content {
      protocol       = "TCP"
      description    = "SSH from ${ingress.value.rule_name}"
      port           = 22
      v4_cidr_blocks = [ingress.value.cidr]
    }
  }

  egress {
    protocol       = "ANY"
    from_port      = 0
    to_port        = 65535
    v4_cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "yandex_vpc_security_group" "private" {
  name        = "private-sg"
  network_id  = yandex_vpc_network.this.id

  ingress {
    protocol          = "TCP"
    description       = "SSH from bastion"
    port              = 22
    security_group_id = yandex_vpc_security_group.bastion.id
  }

  ingress {
    protocol       = "TCP"
    description    = "PostgreSQL"
    port           = 5432
    v4_cidr_blocks = [var.private_subnet_cidr] 
  }

  egress {
    protocol       = "ANY"
    from_port      = 0
    to_port        = 65535
    v4_cidr_blocks = ["0.0.0.0/0"]
  }
}
