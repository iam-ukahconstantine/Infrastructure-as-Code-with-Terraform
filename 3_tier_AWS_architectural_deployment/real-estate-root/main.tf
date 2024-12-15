# create the VPC
module "vpc" {
  source              = "github.com/iam-ukahconstantine/terraform-infrastructure/3-Tier_aws_architectural_deployment/modules/vpc"
  region              = var.region
  project_name        = var.project_name
  public_cidr_blocks  = var.public_subnet_cidr
  private_cidr_blocks = var.private_subnet_cidr
  DB_cidr_blocks      = var.DB_subnet_cidr
  vpc_cidr            = var.vpc_cidr
  availability_zones  = var.availability_zone
  def_route           = var.def_route

}

# create the NAT Gateway
module "NAT_IGW" {
  source             = "github.com/iam-ukahconstantine/terraform-infrastructure/3-Tier_aws_architectural_deployment/modules/nat_GW"
  eip_domain         = var.eip_domain
  availability_zones = module.vpc.availability_zones
  public_subnet_ids  = module.vpc.public_subnet_ids
  private_subnet_ids = module.vpc.private_subnet_ids
  IGW_id             = module.vpc.IGW_id
  vpc_id             = module.vpc.vpc_id
  def_route          = module.vpc.def_route
  DB_subnet_id       = module.vpc.DB_subnet_id
  project_name       = module.vpc.project_name
}

module "Security_group" {
  source    = "github.com/iam-ukahconstantine/terraform-infrastructure/3-Tier_aws_architectural_deployment/modules/Security_Group"
  vpc_id    = module.vpc.vpc_id
  def_route = module.vpc.def_route
}

module "key_pair" {
  source          = "github.com/iam-ukahconstantine/terraform-infrastructure/3-Tier_aws_architectural_deployment/modules/Key_pair"
  public_key_path = var.public_key_path
  key_pair_name   = var.public_key_name
}

module "ALB" {
  source                          = "github.com/iam-ukahconstantine/terraform-infrastructure/3-Tier_aws_architectural_deployment/modules/ALB"
  project_name                    = module.vpc.project_name
  lb_type                         = var.lb_type
  elb_SG_id                       = module.Security_group.elb_SG_id
  private_subnet_ids              = module.vpc.private_subnet_ids
  vpc_id                          = module.vpc.vpc_id
  health_check_path               = var.health_check_path
  tg_port                         = var.tg_port
  tg_protocol                     = var.tg_protocol
  tg_listener_default_action_type = var.tg_listener_default_action_type
  instance_id                     = module.EC2.instance_id
}

module "EC2" {
  source                                             = "github.com/iam-ukahconstantine/terraform-infrastructure/3-Tier_aws_architectural_deployment/modules/EC2"
  image_name                                         = var.image_name
  architecture_type                                  = var.architecture_type
  virtualization_type                                = var.virtualization_type
  root_device_type                                   = var.root_device_type
  image_owners                                       = var.image_owners
  launch_template_instance_type                      = var.launch_template_instance_type
  launch_template_image_1                            = var.launch_template_image_1
  launch_template_image_2                            = var.launch_template_image_2
  launch_template_name_prefix                        = var.launch_template_name_prefix
  autoscaling_desired_capacity                       = var.autoscaling_desired_capacity
  autoscaling_max_size                               = var.autoscaling_max_size
  autoscaling_min_size                               = var.autoscaling_min_size
  private_subnet_ids                                 = module.vpc.private_subnet_ids
  public_key_name                                    = module.key_pair.public_key_name
  elb_SG_id                                          = module.Security_group.elb_SG_id
  value_for_on_demand_base_capacity                  = var.value_for_on_demand_base_capacity
  value_for_on_demand_percentage_above_base_capacity = var.value_for_on_demand_percentage_above_base_capacity
  value_of_spot_allocation_strategy                  = var.value_of_spot_allocation_strategy
  weighted_capacity_1                                = var.weighted_capacity_1
  weighted_capacity_2                                = var.weighted_capacity_2
  target_group_arn                                   = module.ALB.target_group_arn
}
