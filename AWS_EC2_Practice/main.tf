# 1. Configure the AWS Provider
terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0" # Ensures you use a stable, modern version
    }
  }
}

provider "aws" {
  region = "us-east-1" # You can change this to your preferred AWS region
}

# 2. Define the EC2 Instance Resource
resource "aws_instance" "my_first_ec2" {
  ami           = "ami-0c7217cdde317cfec" # Official Ubuntu 22.04 LTS AMI ID for us-east-1
  instance_type = "t3.micro"              # Free-tier eligible hardware size

  tags = {
    Name        = "HandsOn-EC2"
    Environment = "Dev"
  }
}
