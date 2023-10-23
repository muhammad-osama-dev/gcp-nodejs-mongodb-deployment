variable "project_id" {
  type = string
}
variable "vm_name" {
    type = string 
}

variable "vm_type" {
  type = string
  default = "n2-standard-2"
}

variable "vm_zone" {
  type = string 
}

variable "vm_image" {
  type        = string
  default     = "debian-cloud/debian-11"
}

variable "labels_tags" {
    type = list(string)
}

variable "vpc_name" {
  type = string
}

variable "private_subnet_name" {
  type = string
}

variable "gke_subnet_name" {
  type = string 
}

variable "sa_email" {
  type = string
}

variable "sa_key" {
  type = string
}

variable "private_ip_cidr_range" {
  type = string
}


### GKE

variable "gke_name" {
  type = string
}

variable "region1" {
  type = string
}

variable "repo_id" {
  type = string
}