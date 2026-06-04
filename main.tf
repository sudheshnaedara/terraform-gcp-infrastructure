provider "google" {
  project = var.project_id
  region  = var.region
}

# VPC Network
resource "google_compute_network" "vpc" {
  name                    = "asml-vpc-${var.environment}"
  auto_create_subnetworks = false
}

# Subnet
resource "google_compute_subnetwork" "subnet" {
  name          = "asml-subnet-${var.environment}"
  ip_cidr_range = "10.0.0.0/24"
  region        = var.region
  network       = google_compute_network.vpc.id
}

# Firewall — allow SSH through IAP only
resource "google_compute_firewall" "allow_iap_ssh" {
  name    = "allow-iap-ssh-${var.environment}"
  network = google_compute_network.vpc.name

  allow {
    protocol = "tcp"
    ports    = ["22"]
  }

  source_ranges = ["35.235.240.0/20"]
}

# GCS bucket for build artifacts
resource "google_storage_bucket" "artifacts" {
  name     = "asml-build-artifacts-sdedara-${var.environment}"
  location = var.region

  versioning {
    enabled = true
  }
}

# IAM — give service account storage access
resource "google_project_iam_member" "storage_admin" {
  project = var.project_id
  role    = "roles/storage.admin"
  member  = "serviceAccount:terraform-sa@${var.project_id}.iam.gserviceaccount.com"
}