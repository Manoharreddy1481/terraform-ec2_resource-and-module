# main.tf

# Define provider
provider "aws" {
  region = "us-east-1"  # Replace with your desired region
}

# Get available availability zones
data "aws_availability_zones" "available" {}

# Create a security group allowing SSH access
resource "aws_security_group" "ec2_sg" {
  name        = "ec2_security_group"
  description = "Allow SSH inbound traffic"

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]  # Allow SSH from anywhere (you may restrict this)
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

# Create EC2 instances in 3 availability zones
resource "aws_instance" "ec2_instance" {
  count         = 3  # Create one instance per AZ
  ami           = "ami-09c813fb71547fc4f"  # Amazon Linux 2 AMI (replace with preferred AMI ID)
  instance_type = "t2.micro"               # Small instance type for demo purposes

  # Launch each instance in a different availability zone
  availability_zone = data.aws_availability_zones.available.names[count.index]

  security_groups = [aws_security_group.ec2_sg.name]

  tags = {
    Name = "Instance-${count.index + 1}"
  }
}
