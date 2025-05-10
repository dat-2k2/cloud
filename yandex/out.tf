output "internal_ipv4" {
  value = yandex_compute_instance.server_instance.network_interface.0.ip_address
}

output "instance_ip" {
  value = yandex_compute_instance.server_instance.network_interface.0.nat_ip_address
}