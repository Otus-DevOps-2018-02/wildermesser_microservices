resource "google_compute_firewall" "firewall_ssh" {
  name        = "default-allow-ssh-${var.machine_name}"
  network     = "default"
  description = "Allow ssh by default"

  allow {
    protocol = "tcp"
    ports    = ["22"]
  }
  source_ranges = ["0.0.0.0/0"]
  target_tags   = ["${var.machine_name}"]
}

resource "google_compute_firewall" "firewall_http" {
  name    = "default-allow-http-${var.machine_name}"
  network = "default"

  allow {
    protocol = "tcp"
    ports    = ["80"]
  }

  source_ranges = ["0.0.0.0/0"]
  target_tags   = ["${var.machine_name}"]
}


resource "google_dns_managed_zone" "branch" {
  name     = "${var.dns_zone_name}"
  dns_name = "${var.dns_zone_fqn}"
}

resource "google_dns_record_set" "branch" {
  name = "${var.dns_record_name}.${google_dns_managed_zone.branch.dns_name}"
  type = "A"
  ttl  = 300

  managed_zone = "${google_dns_managed_zone.branch.name}"

  rrdatas = ["${google_compute_instance.branch.network_interface.0.access_config.0.assigned_nat_ip}"]
}
