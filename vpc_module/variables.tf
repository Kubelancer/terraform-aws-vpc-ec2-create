variable "region" {
  default = "us-east-2"
  description = "Development VPC region"
}
variable "vpc_cidr_block" {}
variable "dev_vpc_public_subnet-1a_cidr" {}
variable "dev_vpc_public_subnet-1b_cidr" {}
variable "dev_vpc_public_subnet-1c_cidr" {}
variable "dev_vpc_private_subnet-1a_cidr" {}
variable "dev_vpc_private_subnet-1b_cidr" {}
variable "dev_vpc_private_subnet-1c_cidr" {}
variable "dev_vpc_elastic_ip_for_nat_gw_association" {}
variable "dev_instance_keypair" {}
variable "dev_instance_type" {}