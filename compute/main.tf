resource "google_service_account" "my_service_account" {
  account_id   = "my-service-account-id"  # Replace with the desired account_id
  display_name = "My Service Account"
}

resource "google_compute_instance" "my-private-vm" {
  name         = var.vm_name
  machine_type = var.vm_type
  zone         = var.vm_zone

  tags = var.labels_tags

  boot_disk {
     initialize_params {
      image = var.vm_image
    }
  }

  
  network_interface {
    network = var.vpc_name
    subnetwork = var.private_subnet_name
    access_config {
    }
  }

  metadata_startup_script = "echo hi > /test.txt"

  service_account {
    # Google recommends custom service accounts that have cloud-platform scope and permissions granted via IAM Roles.
    email  = google_service_account.my_service_account.email
    scopes = ["cloud-platform"]
  }
}