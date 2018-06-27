resource "google_container_cluster" "primary" {
  project            = "docker-201803"
  name               = "cluster-tf"
  zone               = "us-central1-a"
  initial_node_count = 3

  master_auth {
    username = ""
    password = ""
  }

  addons_config = {
    kubernetes_dashboard {
      disabled = false
    }
  }

  node_config {
    oauth_scopes = [
      "https://www.googleapis.com/auth/compute",
      "https://www.googleapis.com/auth/devstorage.read_only",
      "https://www.googleapis.com/auth/logging.write",
      "https://www.googleapis.com/auth/monitoring",
    ]

    disk_size_gb = 10
    machine_type = "g1-small"

    tags = ["kube-tf-node"]
  }
}
