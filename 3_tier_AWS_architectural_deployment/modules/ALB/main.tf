resource "aws_lb" "My_ALB" {
  name               = "${var.project_name}-alb"
  internal           = false
  load_balancer_type = var.lb_type
  security_groups    = [ var.elb_SG_id ]
  subnets            = var.private_subnet_ids

  tags = {
    Name = "${var.project_name}_alb"
  }
}
resource "aws_lb_target_group" "my_alb_target_group" {
  name        = "${var.project_name}-alb-tg"
  port        = var.tg_port
  protocol    = var.tg_protocol
  vpc_id      = var.vpc_id

  health_check {
    path = var.health_check_path
    protocol =var.tg_protocol
  }
}

resource "aws_lb_listener" "tg_listener" {
  load_balancer_arn = aws_lb.My_ALB.arn
  port              = var.tg_port
  protocol          = var.tg_protocol

  default_action {
    type             = var.tg_listener_default_action_type
    target_group_arn = aws_lb_target_group.my_alb_target_group.arn
  }
}
# resource "aws_lb_target_group_attachment" "target_instances" {
#   target_group_arn = aws_lb_target_group.my_alb_target_group.arn
#   target_id = var.instance_id
#   port = var.tg_port
# }