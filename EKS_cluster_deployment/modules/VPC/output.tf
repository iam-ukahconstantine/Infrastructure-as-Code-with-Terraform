output "public_subnets" {
  description = "List of public subnets and their details"
  value = {
    for k, v in aws_subnet.subnets : k => {
      cidr_block        = v.cidr_block
      availability_zone = v.availability_zone
    }
  }
}

output "private_subnets" {
  description = "List of private subnets and their details"
  value = {
    for k, v in aws_subnet.subnets : k => {
      cidr_block        = v.cidr_block
      availability_zone = v.availability_zone
    }
  }
}

output "project_name" {
  value = var.project_name
}

output "public_subnet_ids" { 
  value = [for s in aws_subnet.subnets : s.id if s.map_public_ip_on_launch]
}
output "vpc_id" {
  value = aws_vpc.vpc.id
}
output "def_route" {
  value = var.def_route 
}
output "private_subnet_ids" {
  value = [for s in aws_subnet.subnets : s.id if !s.map_public_ip_on_launch]
}