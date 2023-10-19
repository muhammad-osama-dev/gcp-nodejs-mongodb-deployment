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

variable "vpc_name" {
  type = string
}

variable "private_subnet_name" {
  type = string
}

variable "sa_email" {
  type = string
}