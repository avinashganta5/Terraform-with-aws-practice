terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }
}

provider "aws" {
  region = "us-east-1"
}

# 1. Create a Security Group (Virtual Firewall)
resource "aws_security_group" "web_firewall" {
  name        = "web-server-sg"
  description = "Allow inbound HTTP web traffic"

  # Inbound Rule: Allow HTTP traffic from anyone on the internet
  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  # Outbound Rule: Allow the server to download software updates
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1" # "-1" means all protocols
    cidr_blocks = ["0.0.0.0/0"]
  }
}

# 2. Launch the EC2 Instance
resource "aws_instance" "my_web_server" {
  ami                    = "ami-0c7217cdde317cfec" # Ubuntu 22.04 LTS
  instance_type          = "t3.micro"
  vpc_security_group_ids = [aws_security_group.web_firewall.id] # Attach firewall

  # User Data: A bash script that executes automatically on first boot
  user_data = <<-EOF
              #!/bin/bash
              sudo apt-get update -y
              sudo apt-get install nginx -y
              sudo systemctl start nginx
              sudo systemctl enable nginx
              echo "<h1>Hello from your Terraform-managed EC2! 🔥</h1>" | sudo tee /var/www/html/index.html
              EOF

  tags = {
    Name = "Terraform-Automated-Web-Server"
  }
}

# 3. Output the Public URL
output "web_server_url" {
  description = "The public URL of your web server"
  value       = "http://${aws_instance.my_web_server.public_ip}"
}
