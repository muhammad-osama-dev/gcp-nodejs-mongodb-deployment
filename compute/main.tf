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
    
  }

  # metadata = {
  #   startup_script = "./startup-private-vm.sh"
  # }
  metadata_startup_script = file("./compute/startup-private-vm.sh")

  service_account {
    # Google recommends custom service accounts that have cloud-platform scope and permissions granted via IAM Roles.
    email  = "admin-sdk@itisv-401212.iam.gserviceaccount.com"
    scopes = ["cloud-platform"]
  }
}




