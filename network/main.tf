# VPC
resource "google_compute_network" "this" {
  name = "${var.vpc_name}-vpc"
  delete_default_routes_on_create = false
  auto_create_subnetworks = false
  routing_mode = "REGIONAL"
}

# Subnets
resource"google_compute_subnetwork" "public" {
    count= 1
    name="${var.vpc_name}-public-subnetwork"
    ip_cidr_range= var.public_ip_cidr_range
    region=var.region1
    network=google_compute_network.this.id
    private_ip_google_access =true
}

resource"google_compute_subnetwork" "private_ip_cidr_range" {
    count= 1
    name="${var.vpc_name}-private-subnetwork"
    ip_cidr_range= var.private_ip_cidr_range
    region=var.region2
    network=google_compute_network.this.id
    private_ip_google_access =true
}