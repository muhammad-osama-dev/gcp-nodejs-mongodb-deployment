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


module "compute" {
    source = "./compute"
    vm_name = var.vm_name
    vm_type = var.vm_type
    vm_zone = var.vm_zone
    vm_image = var.vm_image
    labels_tags = var.labels_tags
    vpc_name = module.network.vpc_name
    private_subnet_name = module.network.private_subnet_name
    sa_email = module.iam.sa_email
}

module "iam" {
  source = "./iam"
  project_id = var.project_id
}

module "storage" {
  source = "./storage"
  region2 = var.region2
  repo_desc = var.repo_desc
  repo_id = var.repo_id
  sa_email = module.iam.sa_email
  project_id = var.project_id
}