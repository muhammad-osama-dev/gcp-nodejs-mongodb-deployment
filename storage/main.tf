resource "google_artifact_registry_repository" "my-repo" {
  location      = "us-east1"
  repository_id = var.repo_id
  description   = var.repo_desc
  format        = "DOCKER"

  docker_config {
    immutable_tags = false
  }
}



# resource "google_artifact_registry_repository_iam_binding" "iam_binding" {
#   repository = google_artifact_registry_repository.my-repo.name
#   location   = var.region2
#   role       = "roles/artifactregistry.reader"
#   project    = var.project_id

#   members = [
#     "serviceAccount:${var.sa_email}"
#   ]
# }