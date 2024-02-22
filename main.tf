provider "aws" {
  profile = "cyber24" #Atento aqui, configurar profile com nome cyber24 ou trocar pra default (aws configure --profile default)
  region  = "us-west-2" 
}

resource "aws_vpc" "my_vpc" {
  cidr_block = "10.0.0.0/16"
  enable_dns_support   = true
  enable_dns_hostnames = true
}

resource "aws_subnet" "public_subnet" {
  vpc_id     = aws_vpc.my_vpc.id
  cidr_block = "10.0.1.0/24"
  map_public_ip_on_launch = true
}

resource "aws_subnet" "private_subnet" {
  vpc_id     = aws_vpc.my_vpc.id
  cidr_block = "10.0.2.0/24"
}

resource "aws_instance" "wordpress" {
  ami           = "ami-0c55b159cbfafe1f0" # Change to a valid AMI (ubuntu 22 for example)
  instance_type = "t2.micro"
  subnet_id     = aws_subnet.public_subnet.id

  tags = {
    Name = "WordPress"
  }
}
