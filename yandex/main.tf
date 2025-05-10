terraform {
  required_providers {
    yandex = {
      source = "yandex-cloud/yandex"
      version = "=0.83.0" 
    }
  }
  required_version = ">= 0.13"
}

# Настройка провайдера Yandex Cloud
provider "yandex" {
  zone      = "ru-central1-a"
}

resource "yandex_compute_disk" "server_disk" {
  name     = "nguen_disk"             
  type     = "network-hdd"                  
  zone     = "ru-central1-a"                
  size     = "20"                           
  image_id = "fd85u0rct32prepgjlv0"         # ubuntu-22-04-lts-v20240311 
  
} 

data "yandex_vpc_network" "default_network" {
  name = "default"  # use default network
}

resource "yandex_vpc_subnet" "server_subnet" {
  name           = "nguen-subnet"
  zone           = "ru-central1-a"
  network_id     = data.yandex_vpc_network.default_network.id 
  v4_cidr_blocks = ["192.168.70.0/24"]    
}

resource "yandex_vpc_security_group" "server_group" {
  name        = "nguen-security-group"
  network_id  = data.yandex_vpc_network.default_network.id
  description = "Security group for nguen-tf"
}

resource "yandex_vpc_security_group_rule" "rule_ssh" {
  security_group_binding = yandex_vpc_security_group.server_group.id 
  direction         = "ingress"
  description       = "SSH"
  protocol          = "TCP"
  port              = 22
  v4_cidr_blocks    = ["0.0.0.0/0"] 
}

resource "yandex_vpc_security_group_rule" "rule_http" {
  security_group_binding = yandex_vpc_security_group.server_group.id 
  direction         = "ingress"
  description       = "HTTP"
  protocol          = "TCP"
  port              = 80
  v4_cidr_blocks    = ["0.0.0.0/0"] 
}

resource "yandex_vpc_security_group_rule" "rule_https" {
  security_group_binding = yandex_vpc_security_group.server_group.id 
  direction         = "ingress"
  description       = "SSH"
  protocol          = "TCP"
  port              = 443
  v4_cidr_blocks    = ["0.0.0.0/0"] 
}

resource "yandex_vpc_security_group_rule" "egress_all" {
  security_group_binding = yandex_vpc_security_group.server_group.id
  direction         = "egress"
  description       = "Allow all outgoing traffic"
  protocol          = "ANY"
  v4_cidr_blocks    = ["0.0.0.0/0"]
}

resource "yandex_compute_instance" "server_instance" {
  name = "nguen-tf"               

  resources {
    cores  = 2  # 2 cores
    memory = 2  # gb
  }

  boot_disk {
    disk_id = yandex_compute_disk.server_disk.id 
  }

  network_interface {
    subnet_id = yandex_vpc_subnet.server_subnet.id  
    nat       = true                           
    security_group_ids = [yandex_vpc_security_group.server_group.id]
  }

  # Метаданные ВМ
  metadata = {
    user-data = "${file("meta.txt")}"
  }
}