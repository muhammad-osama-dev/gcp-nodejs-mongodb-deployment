output "sa_email" {
  value = google_service_account.sa.email
}

output "sa_key" {
  value = google_service_account_key.sa_key.private_key
}