# create a VPC block
resource "aws_vpc" "vpc" {
  cidr_block       = var.vpc_cidr
  instance_tenancy = "default"
  enable_dns_hostnames = true
  enable_dns_support = true

  tags = {
    Name = "${var.project_name}-vpc"
  }
}
# Create your public subnets
resource "aws_subnet" "public_subnets" {
  for_each = tomap({
    for idx, az in var.availability_zones : idx => {
      availability_zone = az
      cidr_block        = var.public_cidr_blocks[idx]
    }
  })

  vpc_id                  = aws_vpc.vpc.id
  cidr_block              = each.value.cidr_block
  availability_zone       = each.value.availability_zone
  map_public_ip_on_launch = true

  tags = {
    Name = "Public Subnet in ${each.value.availability_zone}"
  }
}

# Create your private subnets
resource "aws_subnet" "private_subnets" {
  for_each = tomap({
    for idx, az in var.availability_zones : idx => {
      availability_zone = az
      cidr_block        = var.private_cidr_blocks[idx]
    }
  })

  vpc_id                  = aws_vpc.vpc.id
  cidr_block              = each.value.cidr_block
  availability_zone       = each.value.availability_zone
  map_public_ip_on_launch = false

  tags = {
    Name = "Private Subnet in ${each.value.availability_zone}"
  }
}

# Create a Database Subnet
resource "aws_subnet" "DB_subnets" {
  for_each = tomap({
    for idx, az in var.availability_zones : idx => {
      availability_zone = az
      cidr_block        = var.DB_cidr_blocks[idx]
    }
  })

  vpc_id                  = aws_vpc.vpc.id
  cidr_block              = each.value.cidr_block
  availability_zone       = each.value.availability_zone
  map_public_ip_on_launch = false

  tags = {
    Name = "DB Subnet in ${each.value.availability_zone}"
  }
}

resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.vpc.id
  tags = {
    Name = "My_VPC_IGW"
  }
}

resource "aws_route_table" "vpc-rtb" {
  vpc_id = aws_vpc.vpc.id
  route {
    cidr_block = var.def_route
    gateway_id = aws_internet_gateway.igw.id
  }

}
resource "aws_route_table_association" "vpc-rtb-asso" {
  for_each = aws_subnet.public_subnets

  subnet_id = each.value.id
  route_table_id = aws_route_table.vpc-rtb.id
}

