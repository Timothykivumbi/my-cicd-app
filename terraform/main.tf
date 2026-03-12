terraform {
  required_providers {
    aws = { source = "hashicorp/aws", version = "~> 5.0" }
  }
}

provider "aws" { region = var.aws_region }

# Security group — open port 3000 and SSH
resource "aws_security_group" "app_sg" {
  name = "app-sg"
  ingress { from_port=22, to_port=22, protocol="tcp", cidr_blocks=["0.0.0.0/0"] }
  ingress { from_port=3000, to_port=3000, protocol="tcp", cidr_blocks=["0.0.0.0/0"] }
  egress  { from_port=0, to_port=0, protocol="-1", cidr_blocks=["0.0.0.0/0"] }
}

# EC2 instance — t2.micro is AWS free tier
resource "aws_instance" "app_server" {
  ami                    = var.ami_id
  instance_type          = "t2.micro"
  key_name               = var.key_name
  vpc_security_group_ids = [aws_security_group.app_sg.id]

  user_data = <<-EOF
    #!/bin/bash
    apt-get update -y
curl -fsSL https://deb.nodesource.com/setup_18.x | bash -
    apt-get install -y nodejs
    npm install -g pm2
  EOF

  tags = { Name = "cicd-app-server" }
}

output "instance_ip" { value = aws_instance.app_server.public_ip }
