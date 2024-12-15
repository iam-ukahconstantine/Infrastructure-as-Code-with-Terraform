module "VPC" {
  source = "../modules/VPC"

  region       = var.region
  project_name = var.project_name
  vpc_cidr     = var.vpc_cidr
  def_route    = var.def_route
}

module "NAT-GW" {
  source             = "../modules/NAT_GW"
  eip_domain         = var.eip_domain
  project_name       = module.VPC.project_name
  public_subnet_ids  = module.VPC.public_subnet_ids
  vpc_id             = module.VPC.vpc_id
  def_route          = module.VPC.def_route
  private_subnet_ids = module.VPC.private_subnet_ids
}

module "IAM_ROLE_POLICIES" {
  source                           = "../modules/IAM_POLICIES"
  private_subnet_ids               = module.VPC.private_subnet_ids
  eks-capacity_type                = var.eks-capacity_type
  eks-instance_types               = var.eks-instance_types
  labels                           = var.labels
  access_config_autentication_mode = var.access_config_autentication_mode
  scaling_config_desired_size      = var.scaling_config_desired_size
  scaling_config_max_size          = var.scaling_config_max_size
  scaling_config_min_size          = var.scaling_config_min_size
  update_config_max_unavailable    = var.update_config_max_unavailable
  project_name                     = module.VPC.project_name
}

module "Bastion_Host_key_file" {
  source          = "../modules/Bastion_Host_key_file"
  public_key_path = var.public_key_path
  key_pair_name   = var.public_key_name
}

module "Bastion_EC2" {
  source            = "../modules/Bastion_EC2"
  instance_type     = var.instance_type
  vpc_id            = module.VPC.vpc_id
  root_device_type  = var.root_device_type
  image_name        = var.image_name
  image_owners      = var.image_owners
  public_key_name   = module.Bastion_Host_key_file.public_key_name
  architecture_type = var.architecture_type
  def_route         = module.VPC.def_route
  public_subnet_ids = module.VPC.public_subnet_ids
}