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


resource "aws_launch_template" "mixed_instances" {
  name_prefix   = var.launch_template_name_prefix
  image_id      = data.aws_ami.image.id
  instance_type = var.launch_template_instance_type
  key_name = var.public_key_name
  vpc_security_group_ids = [ var.elb_SG_id ]
}

resource "aws_autoscaling_group" "my_auto_group" {
  capacity_rebalance  = true
  desired_capacity    = var.autoscaling_desired_capacity
  max_size            = var.autoscaling_max_size
  min_size            = var.autoscaling_min_size
  vpc_zone_identifier = var.private_subnet_ids
  target_group_arns = [ var.target_group_arn ]

  mixed_instances_policy {
    instances_distribution {
      on_demand_base_capacity                  = var.value_for_on_demand_base_capacity
      on_demand_percentage_above_base_capacity = var.value_for_on_demand_percentage_above_base_capacity
      spot_allocation_strategy                 = var.value_of_spot_allocation_strategy
    }

    launch_template {
      launch_template_specification {
        launch_template_id = aws_launch_template.mixed_instances.id
      }

      override {
        instance_type     = var.launch_template_image_1
        weighted_capacity = var.weighted_capacity_1
      }

      override {
        instance_type     = var.launch_template_image_2
        weighted_capacity = var.weighted_capacity_2
      }
    }
  }
}