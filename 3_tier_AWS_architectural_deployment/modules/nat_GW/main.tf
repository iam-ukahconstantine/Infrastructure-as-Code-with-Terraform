# allocate elastic IP address
resource "aws_eip" "nat_eip" {
  for_each = toset(var.availability_zones)
  domain = var.eip_domain

  tags = {
    Name = "${var.project_name}-eip-${each.key}"
  }
}
# create the NAT Gateway
resource "aws_nat_gateway" "project_nat" {
  for_each = toset(var.availability_zones)
  allocation_id = aws_eip.nat_eip[each.key].id
  subnet_id = element(var.public_subnet_ids, index(var.availability_zones, each.key))

  tags = {
    Name = "public-nat-gw-${each.key}"
  }

  depends_on = [var.IGW_id]
}
# create the private route table
resource "aws_route_table" "private_rtb" {
  for_each = toset(var.availability_zones)
  vpc_id = var.vpc_id
  route {
        cidr_block = var.def_route
        nat_gateway_id = aws_nat_gateway.project_nat[each.key].id
}
  tags = {
    Name = "private-rtb-${each.key}"
  }
}
# associate the private subnet with the private route table
resource "aws_route_table_association" "private_subnet_association" {
   for_each      = toset(var.availability_zones)
  subnet_id     = element(var.private_subnet_ids, index(var.availability_zones, each.key))
  route_table_id = aws_route_table.private_rtb[each.key].id
}

# associate the database subnet with the private route table
resource "aws_route_table_association" "DB_subnet_association" {
  for_each      = toset(var.availability_zones)
  subnet_id     = element(var.DB_subnet_id, index(var.availability_zones, each.key))
  route_table_id = aws_route_table.private_rtb[each.key].id
}