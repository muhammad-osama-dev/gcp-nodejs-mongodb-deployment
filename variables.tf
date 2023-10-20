variable "project_id" {
  type = string
}

# Regions 
variable "region1" {
    type = string 
}

variable "region2" {
  type = string
}

# VPC
variable "vpc_name" {
  type = string
}

variable"public_ip_cidr_range" {
    type = string
    description="List of The range of internal addresses that are owned by this subnetwork."
}

variable"private_ip_cidr_range" {
    type = string
    description="List of The range of internal addresses that are owned by this subnetwork."
}


# VM 

variable "vm_name" {
    type = string 
}

variable "vm_type" {
  type = string
  default = "e2-micro"
}

variable "vm_zone" {
  type = string 
}

variable "vm_image" {
  type        = string
  default     = "debian-cloud/debian-10"
}

variable "labels_tags" {
    type = list(string)
}



# Storge


variable "repo_id" {
  type = string 
}

variable "repo_desc" {
  type = string
  default = "docker repository"
}