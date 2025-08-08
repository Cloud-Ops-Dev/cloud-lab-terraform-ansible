# AWS EC2
resource "aws_instance" "lab_ec2" {
  ami           = "ami-0e86e20dae9224db8"  # Ubuntu 22.04, us-east-1 (check latest AMI)
  instance_type = "t2.micro"
  key_name      = var.ssh_key_name
  tags = {
    Name = "LabEC2"
  }
}

# IBM VSI
data "ibm_is_image" "ubuntu" {
  name = "ibm-ubuntu-22-04-3-minimal-amd64-1"
}

resource "ibm_is_vpc" "lab_vpc" {
  name = "lab-vpc"
}

resource "ibm_is_subnet" "lab_subnet" {
  name            = "lab-subnet"
  vpc             = ibm_is_vpc.lab_vpc.id
  zone            = "${var.ibm_region}-1"
  ipv4_cidr_block = "10.240.0.0/24"
}

resource "ibm_is_instance" "lab_vsi" {
  name    = "lab-vsi"
  image   = data.ibm_is_image.ubuntu.id
  profile = "cx2-2x4"
  primary_network_interface {
    subnet = ibm_is_subnet.lab_subnet.id
  }
  vpc  = ibm_is_vpc.lab_vpc.id
  zone = "${var.ibm_region}-1"
  keys = [var.ssh_key_name]
}