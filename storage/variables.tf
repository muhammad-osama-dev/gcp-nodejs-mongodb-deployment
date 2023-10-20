variable "project_id" {
  type = string
}
variable "region2" {
  type = string 
}

variable "repo_id" {
  type = string 
}

variable "repo_desc" {
  type = string
  default = "docker repository"
}

variable "sa_email" {
  type = string
}