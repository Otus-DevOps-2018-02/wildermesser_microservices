output "external_ip" {
  value = "${google_compute_instance.branch.network_interface.0.access_config.0.assigned_nat_ip}"
}
