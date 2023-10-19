# VPC
resource "google_compute_network" "vpc" {
  name = "${var.vpc_name}-vpc"
  delete_default_routes_on_create = false
  auto_create_subnetworks = false
  routing_mode = "REGIONAL"
}

# Subnets
resource"google_compute_subnetwork" "public" {
    name="${var.vpc_name}-public-subnetwork"
    ip_cidr_range= var.public_ip_cidr_range
    region=var.region1
    network=google_compute_network.vpc.id
    private_ip_google_access =true
}

resource"google_compute_subnetwork" "private" {
    name="${var.vpc_name}-private-subnetwork"
    ip_cidr_range= var.private_ip_cidr_range
    region=var.region2
    network=google_compute_network.vpc.id
    private_ip_google_access =true
}


# NAT ROUTER
resource "google_compute_router" "nat-router" {
  name    = "${var.vpc_name}-private-router"
  region  = google_compute_subnetwork.private.region
  network = google_compute_network.vpc.id
}

resource "google_compute_router_nat" "nat" {
  name                               = "${var.vpc_name}-private-router-nat"
  router                             = google_compute_router.nat-router.name
  region                             = google_compute_router.nat-router.region
  nat_ip_allocate_option             = "AUTO_ONLY"
  source_subnetwork_ip_ranges_to_nat = "LIST_OF_SUBNETWORKS"
  subnetwork {
    name                             = "${var.vpc_name}-private-subnetwork"
    source_ip_ranges_to_nat = ["ALL_IP_RANGES"]
  }
}