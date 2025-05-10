terraform {
  required_providers {
    openstack = {
      source  = "terraform-provider-openstack/openstack"
      version = "~> 1.54.1"
    }
  }
}

provider "openstack" {
}

data "openstack_networking_network_v2" "students_network" {
  name = "sutdents-net"  # use default network
}

# Resources
resource "openstack_networking_secgroup_v2" "security_group" {
  name        = "nguen-tf-security-group"
  description = "Security group for the instance"
}

resource "openstack_networking_secgroup_rule_v2" "security_group_rule_ssh" {
  direction         = "ingress"
  ethertype         = "IPv4"
  protocol          = "tcp"
  port_range_min    = 22
  port_range_max    = 22
  remote_ip_prefix  = "192.168.0.0/16"
  security_group_id = openstack_networking_secgroup_v2.security_group.id
}

resource "openstack_networking_secgroup_rule_v2" "security_group_rule_http" {
  direction         = "ingress"
  ethertype         = "IPv4"
  protocol          = "tcp"
  port_range_min    = 80
  port_range_max    = 80
  remote_ip_prefix  = "0.0.0.0/0"
  security_group_id = openstack_networking_secgroup_v2.security_group.id
}

resource "openstack_networking_secgroup_rule_v2" "security_group_rule_https" {
  direction         = "ingress"
  ethertype         = "IPv4"
  protocol          = "tcp"
  port_range_min    = 443
  port_range_max    = 443
  remote_ip_prefix  = "0.0.0.0/0"
  security_group_id = openstack_networking_secgroup_v2.security_group.id
}


resource "openstack_blockstorage_volume_v3" "server_volume" {
  name  = "nguen-tf-volume"
  size  = 20
  image_id = "debian-12"
}

resource "openstack_networking_port_v2" "server_port" {
  network_id     = data.openstack_networking_network_v2.students_network.id
  security_group_ids = [
    openstack_networking_secgroup_v2.security_group.id
  ]
}

# Create an instance
resource "openstack_compute_instance_v2" "nguen_instance" {
  name        = "nguen-tf"
  flavor_name = "m1.small"
  key_pair    = "nguen-tf"

  network {
    port = openstack_networking_port_v2.server_port.id
  }

  block_device {
    uuid                  = openstack_blockstorage_volume_v3.server_volume.id
    source_type           = "volume"
    boot_index            = 0
    destination_type      = "volume"
    delete_on_termination = false
  }
}