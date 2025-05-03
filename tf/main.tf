terraform {
  required_providers {
    openstack = {
      source  = "terraform-provider-openstack/openstack"
      version = "~> 1.51.0"
    }
  }
}




# Resources
resource "openstack_networking_secgroup_v2" "security_group" {
  name        = "${var.var_prefix}-security-group"
  description = "Security group for the instance"
}

resource "openstack_networking_secgroup_rule_v2" "security_group_rule_ssh" {
  direction         = "ingress"
  ethertype         = "IPv4"
  protocol          = "tcp"
  port_range_min    = 22
  port_range_max    = 22
  remote_ip_prefix  = "0.0.0.0/0"
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

resource "openstack_networking_secgroup_rule_v2" "security_group_rule_postgres" {
  direction         = "ingress"
  ethertype         = "IPv4"
  protocol          = "tcp"
  port_range_min    = 5432
  port_range_max    = 5439
  remote_ip_prefix  = "0.0.0.0/0"
  security_group_id = openstack_networking_secgroup_v2.security_group.id
}

resource "openstack_networking_secgroup_rule_v2" "security_group_rule_springboot" {
  direction         = "ingress"
  ethertype         = "IPv4"
  protocol          = "tcp"
  port_range_min    = 8080
  port_range_max    = 8089
  remote_ip_prefix  = "0.0.0.0/0"
  security_group_id = openstack_networking_secgroup_v2.security_group.id
}

resource "openstack_blockstorage_volume_v3" "server_volume" {
  name  = var.volume_name
  size  = var.volume_size
  image_id = var.image_name
}

resource "openstack_networking_port_v2" "server_port" {
  network_id     = var.net_id
  security_group_ids = [
    openstack_networking_secgroup_v2.security_group.id
  ]
}

# Create an instance
resource "openstack_compute_instance_v2" "nguen_instance" {
  name        = var.instance_name
  flavor_name = var.flavor_name
  key_pair    = var.key

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