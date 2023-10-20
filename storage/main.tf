resource "google_artifact_registry_repository_iam_member" "repository_roles" {
  repository = google_artifact_registry_repository.my-repo.name
  location   = google_artifact_registry_repository.my-repo.location
  project    = var.project_id
  role       = "roles/artifactregistry.writer"  # Role for writing to the repository
  member     = "serviceAccount:${var.sa_email}"
}



resource "google_artifact_registry_repository" "my-repo" {
  location      = "us"
  repository_id = var.repo_id
  description   = var.repo_desc
  format        = "DOCKER"

  docker_config {
    immutable_tags = true
  }
}



# resource "google_artifact_registry_repository_iam_binding" "iam_binding" {
#   repository = google_artifact_registry_repository.my-repo.name
#   location   = var.region2
#   role       = "roles/artifactregistry.writer"
#   project    = var.project_id

#   members = [
#     "serviceAccount:${var.sa_email}"
#   ]
# }