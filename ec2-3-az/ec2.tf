resource "aws_security_group" "allow_ssh" {
    name="allow-ssh"
    description = "allow port number 22"

egress {
    from_port = 22
    to_port = 22
    protocol = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]

}
ingress {
    from_port = 22
    to_port = 22
    protocol = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]

}
  
}

resource "aws_instance" "terraform" {
    count = 3
    ami = var.ami_id
    instance_type = var.instance_type
    vpc_security_group_ids = [aws_security_group.allow_ssh.id]
    availability_zone = data.aws_availability_zones.available.names[count.index]

    tags = {
      Name = "Terraform - ${count.index +1}"
    }
  
}