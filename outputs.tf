output "vpc_name" {
  description = "VPC network name"
  value       = google_compute_network.vpc.name
}

output "subnet_name" {
  description = "Subnet name"
  value       = google_compute_subnetwork.subnet.name
}

output "artifacts_bucket" {
  description = "Build artifacts bucket name"
  value       = google_storage_bucket.artifacts.name
}

output "service_account" {
  description = "Terraform service account email"
  value       = "terraform-sa@${var.project_id}.iam.gserviceaccount.com"
}