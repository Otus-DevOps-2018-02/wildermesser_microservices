variable project {
  description = "Project ID"
}

variable region {
  description = "Region"
  default     = "europe-west1"
}

variable zone {
  description = "Zone"
  default     = "europe-west1-b"
}

variable public_key_path {
  description = "Path to the public key used for ssh access"
}

variable private_key_path {
  description = "Path to the private key used for ssh access in provisioning"
}

variable machine_type {
  description = "GCE machine type"
  default = "f1-micro"
}

variable machine_name {
  description = "GCE machine name"
}

variable "disk_image" {
  description = "Disk image"
  default = "ubuntu-1604-lts"
}

variable "disk_size" {
  description = "Disk size in megabytes"
}

variable "dns_zone_name" {
  description = "Name of managed dns zone"
}

variable "dns_zone_fqn" {
  description = "Fqn of managed dns zone"
}

variable "dns_record_name" {
  description = "Name of A dns record of instance"
}
