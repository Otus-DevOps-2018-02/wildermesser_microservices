resource "google_container_cluster" "primary" {
  project            = "docker-201803"
  name               = "cluster-tf"
  zone               = "europe-west2-a"
  initial_node_count = 2


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

    disk_size_gb = 20
    machine_type = "g1-small"

    tags = ["kube-tf-node"]
  }
}
