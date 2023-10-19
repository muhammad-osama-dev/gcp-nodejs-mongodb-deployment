resource "google_service_account" "sa" {
  account_id   = "scv-private-vm"
  display_name = "scv-private-vm"
}

resource "google_project_iam_member" "service_account_roles" {
  project = var.project_id
  role    = "roles/artifactregistry.admin"  # Role for writing to Artifact Registry
  member  = "serviceAccount:${google_service_account.sa.email}"
}



# resource "google_artifact_registry_repository_iam_member" "repository_roles" {
#   repository = google_artifact_registry_repository.my-repo.name
#   location   = google_artifact_registry_repository.my-repo.location
#   project    = var.project_id
#   role       = "roles/artifactregistry.writer"  # Role for writing to the repository
#   member     = "serviceAccount:${google_service_account.sa.email}"
# }



# resource "google_artifact_registry_repository" "my-repo" {
#   location      = "us-east1"
#   repository_id = "my-repository"
#   description   = "example docker repository"
#   format        = "DOCKER"

#   docker_config {
#     immutable_tags = true
#   }
# }