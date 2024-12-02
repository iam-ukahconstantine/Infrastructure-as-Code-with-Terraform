output "region" {
  value = var.region
}
output "project_name" {
  value = var.project_name
}
output "vpc_id" {
  value = aws_vpc.vpc.id
}
output "public_subnet_ids" {
  value = values(aws_subnet.public_subnets)[*].id
}
output "private_subnet_ids" {
  value = values(aws_subnet.private_subnets)[*].id
}
output "DB_subnet_id" {
  value = values(aws_subnet.DB_subnets)[*].id
}
output "IGW_id" {
  value = aws_internet_gateway.igw.id
}
output "availability_zones" {
  value = var.availability_zones
}
output "def_route" {
  value = var.def_route
}