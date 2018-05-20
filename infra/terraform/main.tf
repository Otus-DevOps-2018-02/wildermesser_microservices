provider "google" {
  credentials = "${file("files/account.json")}"
  project     = "${var.project}"
  region      = "${var.region}"
  version     = "1.12"
}

terraform {
  backend "gcs" {
    bucket = "wildermesser-gitlab"
  }
}

resource "google_compute_instance" "branch" {
  name         = "${var.machine_name}"
  machine_type = "${var.machine_type}"
  zone         = "${var.zone}"
  tags         = ["${var.machine_name}"]

  boot_disk {
    initialize_params {
      image = "${var.disk_image}"
      size  = "${var.disk_size}"
    }
  }

  network_interface {
    network       = "default"
    access_config = {}
  }

  metadata {
    ssh-keys = "appuser:${file(var.public_key_path)}"
  }

  connection {
    type        = "ssh"
    user        = "appuser"
    agent       = false
    private_key = "${file(var.private_key_path)}"
  }

  provisioner "remote-exec" {
    script = "files/install-docker.sh"
  }
}
