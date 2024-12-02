resource "aws_eip" "nat-IP" {
  count = length(var.public_subnet_ids)
  domain = var.eip_domain

  tags = {
    Name = "${var.project_name}-eip"
  }
}

resource "aws_nat_gateway" "eks-nat-gw" {
  count = length(var.public_subnet_ids)
  allocation_id = aws_eip.nat-IP.*.id[count.index] 
  subnet_id = var.public_subnet_ids[count.index]
}

resource "aws_route_table" "private_rtb" {
  count = length(var.private_subnet_ids)
  vpc_id = var.vpc_id
  route {
    cidr_block = var.def_route
    nat_gateway_id = aws_nat_gateway.eks-nat-gw[count.index].id
  }

  tags = {
    Name = "${var.project_name}-private_rtb"
  }
}

resource "aws_route_table_association" "private_subnet_association" {
  count = length(var.private_subnet_ids)
  subnet_id      = var.private_subnet_ids[count.index]
  route_table_id = aws_route_table.private_rtb[count.index].id
}