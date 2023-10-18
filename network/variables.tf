variable "project_id" {
  type = string
}

variable "region1" {
    type = string 
}

variable "region2" {
    type = string
}

variable "vpc_name" {
  type = string
}

variable "public_ip_cidr_range" {
    type = string
    description="List of The range of internal addresses that are owned by this subnetwork."
}

variable "private_ip_cidr_range" {
    type = string
    description="List of The range of internal addresses that are owned by this subnetwork."
}