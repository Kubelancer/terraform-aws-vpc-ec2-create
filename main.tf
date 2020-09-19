module "vpc_module" {
  source = "./vpc_module"
  vpc_cidr_block = var.vpc_cidr_block
  dev_vpc_public_subnet-1a_cidr = var.dev_vpc_public_subnet-1a_cidr
  dev_vpc_public_subnet-1b_cidr = var.dev_vpc_public_subnet-1b_cidr
  dev_vpc_public_subnet-1c_cidr = var.dev_vpc_public_subnet-1c_cidr
  dev_vpc_private_subnet-1a_cidr = var.dev_vpc_private_subnet-1a_cidr
  dev_vpc_private_subnet-1b_cidr = var.dev_vpc_private_subnet-1b_cidr
  dev_vpc_private_subnet-1c_cidr = var.dev_vpc_private_subnet-1c_cidr
  dev_instance_keypair = var.dev_instance_keypair
  dev_instance_type = var.dev_instance_type
  dev_vpc_elastic_ip_for_nat_gw_association = var.dev_vpc_elastic_ip_for_nat_gw_association
}