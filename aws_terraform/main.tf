variable "aws_key_pair" {
  default = "/tmp/default-ec2.pem"
  }
terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 3.0"
    }
  }
}

# Configure the AWS Provider
provider "aws" {
  region = "us-east-1"
}

resource "aws_default_vpc" "aws_default_vpc" {

}

data "aws_subnet_ids" "default_subnets" {
  vpc_id = aws_default_vpc.aws_default_vpc.id
}

data "aws_ami" "aws-linux-latest" {
  most_recent = true
  owners = ["amazon"]
  filter {
    name   = "name"
    values = ["amzn2-ami-hvm-*"]
  }
  
}

resource "aws_security_group" "http_server_sg" {

  name   = "http_server_sg"
  vpc_id = aws_default_vpc.aws_default_vpc.id

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 8080
    to_port     = 8080
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = -1
    cidr_blocks = ["0.0.0.0/0"]

  }

  tags = {
    "name" = "http_server_sg"
  }

}

resource "aws_instance" "http_server" {
  #ami                    = "ami-0742b4e673072066f"
  count = 2
  ami = data.aws_ami.aws-linux-latest.id
  key_name               = "default-ec2"
  instance_type          = "t2.micro"
  vpc_security_group_ids = [aws_security_group.http_server_sg.id]
  #subnet_id              = "subnet-e26446ec"
  subnet_id = tolist(data.aws_subnet_ids.default_subnets.ids)[0]
  #user_data = "${file("ec2-instance-user-data.sh")}"
  connection {
    type        = "ssh"
    host        = self.public_ip
    user        = "ec2-user"
    private_key = file(var.aws_key_pair)

  }

}
