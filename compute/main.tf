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

   metadata = {

    # Add metadata key to allow full access to all Cloud APIs
    "enable-oslogin" = "TRUE"
  }

  metadata_startup_script = file("./compute/startup-private-vm.sh")

  service_account {
    # Google recommends custom service accounts that have cloud-platform scope and permissions granted via IAM Roles.
    email  = var.sa_email
    scopes = ["cloud-platform"]
  }
}






####################################### GKE ###############################################

resource "google_service_account" "kubernetes" {
  account_id = "kubernetes"
}
resource "google_container_cluster" "privatecluster"{
  name     = var.gke_name
  network = var.vpc_name
  subnetwork = var.gke_subnet_name
  location = var.region1
  deletion_protection = false  # Set this to false



  remove_default_node_pool = true
  initial_node_count       = 1

  node_locations = [
    "${var.region1}-a",
    "${var.region1}-b",
    # "${var.region1}-c"
  ]
  # master_authorized_networks_config {
  #   cidr_blocks {
  #       cidr_block = "41.43.49.0/32"
  #       display_name = "idk"
  #   }
  # }
  private_cluster_config {
    enable_private_nodes = true
    enable_private_endpoint = false
    master_ipv4_cidr_block = "172.16.0.0/28"
  }
   ip_allocation_policy {
  }
}

resource "google_container_node_pool" "privatecluster-node-pool" {
  name       = "node-pool"
  cluster    = google_container_cluster.privatecluster.name
  node_count = 1
  location   = "us-central1"  
 
  node_config {
    preemptible  = true
    machine_type = "e2-small"
    disk_type    = "pd-standard"
    # disk_type    = var.workern_disktype
    # disk_size_gb = var.workern_disksize
    # image_type   = var.workern_imagetype
    service_account = google_service_account.kubernetes.email
    oauth_scopes    = [ 
      "https://www.googleapis.com/auth/cloud-platform"
    ]
  }
}