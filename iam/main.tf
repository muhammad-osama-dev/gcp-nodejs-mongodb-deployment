resource "google_service_account" "sa" {
  account_id   = "scv-private-vm"
  display_name = "scv-private-vm"
}

# resource "google_project_iam_member" "service_account_roles" {
#   project = var.project_id
#   role    = "roles/artifactregistry.writer"  # Role for writing to Artifact Registry
#   member  = "serviceAccount:${google_service_account.sa.email}"
# }


resource "google_project_iam_member" "k8s_admin" {
  project = var.project_id
  role    = "roles/container.admin"  # This grants full control of Kubernetes Engine resources
  member  = "serviceAccount:${google_service_account.sa.email}"
}

