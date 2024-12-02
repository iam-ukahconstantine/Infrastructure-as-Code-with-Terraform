locals {
  azs     = data.aws_availability_zones.azs.names
  subnets = {
    public_1  = { az = local.azs[0], public = true,  cidr_block = cidrsubnet(var.vpc_cidr, 8, 0) }
    public_2  = { az = local.azs[1], public = true,  cidr_block = cidrsubnet(var.vpc_cidr, 8, 1) }
    private_1 = { az = local.azs[0], public = false, cidr_block = cidrsubnet(var.vpc_cidr, 8, 2) }
    private_2 = { az = local.azs[1], public = false, cidr_block = cidrsubnet(var.vpc_cidr, 8, 3) }
  }
  common_tags = { for key, value in local.subnets : key => merge( 
    { "Name" = "${var.project_name}-${key}" }, value.public ? {"kubernetes.io/role/elb" = "1"} : {} )
  }
  public_subnets = { for k, v in aws_subnet.subnets : k => v.id if v.map_public_ip_on_launch }
}