provider "google" {
  credentials = file("./SA_key.json")
  project     = var.project_id
}

module "network" {
    source = "./network"
    project_id = var.project_id
    region1 = var.region1
    region2 = var.region2
    vpc_name = var.vpc_name
    gke_ip_cidr_range = var.gke_ip_cidr_range
    private_ip_cidr_range = var.private_ip_cidr_range
}


module "compute" {
    source = "./compute"
    project_id = var.project_id
    private_ip_cidr_range = var.private_ip_cidr_range
    repo_id = var.repo_id
    vm_name = var.vm_name
    vm_type = var.vm_type
    vm_zone = var.vm_zone
    vm_image = var.vm_image
    labels_tags = var.labels_tags
    vpc_name = module.network.vpc_name
    private_subnet_name = module.network.private_subnet_name
    gke_subnet_name = module.network.gke_subnet_name
    sa_email = module.iam.sa_email
    sa_key = module.iam.sa_key
    gke_name = var.gke_name
    region1 = var.region1
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
