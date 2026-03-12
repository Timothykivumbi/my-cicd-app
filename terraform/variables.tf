variable "aws_region" { 
  default = "us-east-1" 
}

variable "ami_id" {
  description = "Ubuntu 22.04 AMI for us-east-1"
  default     = "ami-0c7217cdde317cfec"
}

variable "key_name" {
  description = "Name of your AWS key pair"
  default     = "my-ec2-key" # optional, you can override from GitHub Actions
}

variable "instance_type" {
  description = "EC2 instance type"
  default     = "t2.micro"
}