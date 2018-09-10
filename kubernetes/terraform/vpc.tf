resource "google_compute_firewall" "firewall_kube_nodes" {
  name        = "default-allow-kube"
  network     = "default"
  description = "Allow kube ports"
  project     = "docker-201803"

  allow {
    protocol = "tcp"
    ports    = ["30000-32767"]
  }

  source_ranges = ["0.0.0.0/0"]
  target_tags   = ["kube-tf-node"]
}
