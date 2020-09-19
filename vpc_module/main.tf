provider "aws" {
  region = "us-east-2"
}

resource "aws_vpc" "dev_vpc" {
  cidr_block = var.vpc_cidr_block
  enable_dns_hostnames = true

  tags = {
    Name="Development-VPC"
  }
}

resource "aws_subnet" "dev_vpc_public_subnet-1a" {
  cidr_block = var.dev_vpc_public_subnet-1a_cidr
  vpc_id = aws_vpc.dev_vpc.id
  availability_zone = "${var.region}a"

  tags = {
    Name="dev_vpc_public_subnet-1a"
  }
}

resource "aws_subnet" "dev_vpc_public_subnet-1b" {
  cidr_block = var.dev_vpc_public_subnet-1b_cidr
  vpc_id = aws_vpc.dev_vpc.id
  availability_zone = "${var.region}b"

  tags = {
    Name="dev_vpc_public_subnet-1b"
  }
}

resource "aws_subnet" "dev_vpc_public_subnet-1c" {
  cidr_block = var.dev_vpc_public_subnet-1c_cidr
  vpc_id = aws_vpc.dev_vpc.id
  availability_zone = "${var.region}c"

  tags = {
    Name="dev_vpc_public_subnet-1c"
  }
}

resource "aws_subnet" "dev_vpc_private_subnet-1a" {
  cidr_block = var.dev_vpc_private_subnet-1a_cidr
  vpc_id = aws_vpc.dev_vpc.id
  availability_zone = "${var.region}a"

  tags = {
    Name="dev_vpc_private_subnet-1a"
  }
}

resource "aws_subnet" "dev_vpc_private_subnet-1b" {
  cidr_block = var.dev_vpc_private_subnet-1b_cidr
  vpc_id = aws_vpc.dev_vpc.id
  availability_zone = "${var.region}b"

  tags = {
    Name="dev_vpc_private_subnet-1b"
  }
}

resource "aws_subnet" "dev_vpc_private_subnet-1c" {
  cidr_block = var.dev_vpc_private_subnet-1c_cidr
  vpc_id = aws_vpc.dev_vpc.id
  availability_zone = "${var.region}c"

  tags = {
    Name="dev_vpc_private_subnet-1c"
  }
}

resource "aws_route_table" "dev_vpc_public_route_table" {
  vpc_id = aws_vpc.dev_vpc.id

  tags = {
    Name="dev_vpc_public_route_table"
  }
}

resource "aws_route_table" "dev_vpc_private_route_table" {
  vpc_id = aws_vpc.dev_vpc.id

  tags = {
    Name="dev_vpc_private_route_table"
  }
}

resource "aws_route_table_association" "dev_vpc_public_subnet-1a_association" {
  route_table_id = aws_route_table.dev_vpc_public_route_table.id
  subnet_id = aws_subnet.dev_vpc_public_subnet-1a.id
}

resource "aws_route_table_association" "dev_vpc_public_subnet-1b_association" {
  route_table_id = aws_route_table.dev_vpc_public_route_table.id
  subnet_id = aws_subnet.dev_vpc_public_subnet-1b.id
}

resource "aws_route_table_association" "dev_vpc_public_subnet-1c_association" {
  route_table_id = aws_route_table.dev_vpc_public_route_table.id
  subnet_id = aws_subnet.dev_vpc_public_subnet-1c.id
}

resource "aws_route_table_association" "dev_vpc_private_subnet-1a_association" {
  route_table_id = aws_route_table.dev_vpc_private_route_table.id
  subnet_id = aws_subnet.dev_vpc_private_subnet-1a.id
}

resource "aws_route_table_association" "dev_vpc_private_subnet-1b_association" {
  route_table_id = aws_route_table.dev_vpc_private_route_table.id
  subnet_id = aws_subnet.dev_vpc_private_subnet-1b.id
}
resource "aws_route_table_association" "dev_vpc_private_subnet-1c_association" {
  route_table_id = aws_route_table.dev_vpc_private_route_table.id
  subnet_id = aws_subnet.dev_vpc_private_subnet-1c.id
}

resource "aws_eip" "dev_vpc_elastic_ip_for_nat_gw" {
  vpc = true
  associate_with_private_ip = var.dev_vpc_elastic_ip_for_nat_gw_association

  tags = {
    Name="dev_vpc_elastic_ip_for_nat_gw"
  }
}

resource "aws_nat_gateway" "dev_vpc_nat_gw" {
  allocation_id = aws_eip.dev_vpc_elastic_ip_for_nat_gw.id
  subnet_id = aws_subnet.dev_vpc_public_subnet-1a.id

  tags = {
    Name="dev_vpc_nat_gw"
  }
}

resource "aws_route" "dev_vpc_nat_gw_route" {
  route_table_id = aws_route_table.dev_vpc_private_route_table.id
  nat_gateway_id = aws_nat_gateway.dev_vpc_nat_gw.id
  destination_cidr_block = "0.0.0.0/0"
}

resource "aws_internet_gateway" "dev_vpc_internet_gw" {
  vpc_id = aws_vpc.dev_vpc.id

  tags = {
    Name="dev_vpc_internet_gw"
  }
}

resource "aws_route" "dev_vpc_internet_gw_route" {
  route_table_id = aws_route_table.dev_vpc_public_route_table.id
  gateway_id = aws_internet_gateway.dev_vpc_internet_gw.id
  destination_cidr_block = "0.0.0.0/0"
}

data "aws_ami" "ubuntu" {
  most_recent = true

  filter {
    name = "name"
    values = ["ubuntu/images/hvm-ssd/ubuntu-focal-20.04-amd64-server-*"]
  }

  filter {
    name = "virtualization-type"
    values = ["hvm"]
  }

  owners = ["099720109477"]
}

resource "aws_instance" "dev_instance_1" {
  ami = data.aws_ami.ubuntu.id
  instance_type = var.dev_instance_type
  key_name = var.dev_instance_keypair
  security_groups = [aws_security_group.dev_vpc_security_group.id]
  subnet_id = aws_subnet.dev_vpc_public_subnet-1a.id
  associate_public_ip_address = "true"
  root_block_device {
    volume_size = "10"
    volume_type = "gp2"
    delete_on_termination = "true"
  }
  user_data = <<EOF
#! /bin/bash
sudo apt-get update
sudo apt-get install -y apache2
sudo systemctl start apache2
sudo systemctl enable apache2
echo "<h1>Deployed via Terraform</h1>" | sudo tee /var/www/html/index.html
EOF

  tags = {
    Name="dev_instance_1"
  }
}

resource "aws_security_group" "dev_vpc_security_group" {
  name = "dev_vpc_security_group"
  description = "dev_vpc_security_group"
  vpc_id = aws_vpc.dev_vpc.id

  ingress {
    from_port = 22
    protocol = "tcp"
    to_port = 22
    description = "dev_vpc_security_group_ssh_port"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port = 80
    protocol = "tcp"
    to_port = 80
    description = "dev_vpc_security_group_80_port"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port = 0
    protocol = "-1"
    to_port = 0
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name="dev_vpc_security_group"
  }
}

