# create an Elastic Load Balancer security group.
resource "aws_security_group" "elb_SG" {
  name        = "ELB-SG"
  description = "All inbound traffic into the Elastic Load Balancer"
  vpc_id      = var.vpc_id

  tags = {
    Name = "All ELB_specified traffic"
  }

  lifecycle {
    create_before_destroy = true
  }
}

# Create an HTTP inbound rule
resource "aws_vpc_security_group_ingress_rule" "Inbound_HTTP" {
  security_group_id = aws_security_group.elb_SG.id
  cidr_ipv4         = var.def_route
  from_port         = 80
  ip_protocol       = "tcp"
  to_port           = 80
}

# Create an HTTPS inbound rule 
resource "aws_vpc_security_group_ingress_rule" "HTTPS-INBOUND" {
  security_group_id = aws_security_group.elb_SG.id
  cidr_ipv4         = var.def_route
  from_port         = 443
  ip_protocol       = "tcp"
  to_port           = 443
}

# Create the outbound rule of the security group
resource "aws_vpc_security_group_egress_rule" "allow_all_traffic_ipv4" {
  security_group_id = aws_security_group.elb_SG.id
  cidr_ipv4         = var.def_route
  ip_protocol       = "-1" 
}

