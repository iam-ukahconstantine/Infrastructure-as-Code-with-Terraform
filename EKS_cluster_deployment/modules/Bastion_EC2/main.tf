# Get the instance ami id specifying your preferred filter
data "aws_ami" "image" {  
  owners           = ["${var.image_owners}"]
  most_recent = true
  include_deprecated = false

  filter {
    name   = "name"
    values = ["${var.image_name}"]
  }

  filter {
    name   = "root-device-type"
    values = ["${var.root_device_type}"]
  }

  filter {
    name = "architecture"
    values = [ "${var.architecture_type}" ]
  }
}

resource "aws_instance" "bastion_host" {
  ami = data.aws_ami.image.id
  instance_type = var.instance_type
  key_name = var.public_key_name
  subnet_id = var.public_subnet_ids[0]
  security_groups = [ aws_security_group.allow_ssh.id ]
}

resource "aws_security_group" "allow_ssh" {
  name        = "allow_ssh"
  description = "Allow SSH inbound traffic and all outbound traffic"
  vpc_id      = var.vpc_id

  tags = {
    Name = "allow_ssh"
  }
}

resource "aws_vpc_security_group_ingress_rule" "SSH_Inbound" {
  security_group_id = aws_security_group.allow_ssh.id
  cidr_ipv4         = var.def_route
  from_port         = 22
  ip_protocol       = "tcp"
  to_port           = 22
}

resource "aws_vpc_security_group_egress_rule" "allow_all_traffic_ipv4" {
  security_group_id = aws_security_group.allow_ssh.id
  cidr_ipv4         = var.def_route
  ip_protocol       = "-1" 
}