provider "google" {
  credentials = file("./itisv-401212-d51ce4e7851a.json")
  project     = var.project_id
}

module "network" {
    source = "./network"
    project_id = var.project_id
    region1 = var.region1
    region2 = var.region2
    vpc_name = var.vpc_name
    public_ip_cidr_range = var.public_ip_cidr_range
    private_ip_cidr_range = var.private_ip_cidr_range
}