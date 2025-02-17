region               = "us-east-1"
project              = "Terraform"
vpc_cidr             = "12.0.0.0/16"
instance_tenancy     = "default"
enable_dns_hostnames = "true"
enable_dns_support   = "true"
azs                  = ["us-east-1a", "us-east-1b", "us-east-1c"]
public_subnet_cidr   = ["12.0.1.0/24", "12.0.2.0/24", "12.0.3.0/24"]
public_ip            = true
private_subnet_cidr  = ["12.0.4.0/24", "12.0.5.0/24", "12.0.6.0/24"]
env                  = "dev"
instance_type        = "t2.micro"
key_name             = "Ravi_Virginia"
instance_names       = ["Jenkins", "Docker", "Kubernetes"]
allowed_ports        = ["22", "80", "443"]
amis = {
  ap-south-1     = "ami-00bb6a80f01f03502"
  us-east-1      = "ami-04b4f1a9cf54c11d0"
  us-east-2      = "ami-0cb91c7de36eed2cb"
  ap-southeast-1 = "ami-0672fd5b9210aa093"
}