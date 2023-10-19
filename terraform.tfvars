project_id = "itisv-401212"
region1 = "us-central1"
region2 = "us-east1"
vpc_name = "project"
public_ip_cidr_range = "10.10.10.0/24"
private_ip_cidr_range = "10.10.20.0/24"


# VM

vm_name = "my-private-instance"
vm_type = "e2-micro"
vm_zone = "us-east1-b"
vm_image = "debian-cloud/debian-10"
labels_tags = [ "private-subnet" ]
