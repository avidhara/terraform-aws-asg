resource "aws_autoscaling_group" "this" {
  count = var.enable_autoscaling_group ? 1 : 0
  name  = format("%s-asg", var.name)

  max_size             = var.max_size
  min_size             = var.min_size
  default_cooldown     = var.default_cooldown
  launch_configuration = var.enable_launch_configuration ? aws_launch_configuration.this[0].id : null

  dynamic "launch_template" {
    for_each = var.enable_launch_template ? aws_launch_template.this.*.id : []
    content {
      id      = aws_launch_template.this[0].id
      version = "$Latest"
    }

  }
  health_check_grace_period = var.health_check_grace_period
  health_check_type         = var.health_check_type
  desired_capacity          = var.desired_capacity
  force_delete              = var.force_delete

  load_balancers      = var.load_balancers
  vpc_zone_identifier = var.vpc_zone_identifier

  target_group_arns    = var.target_group_arns
  termination_policies = var.termination_policies
  suspended_processes  = var.suspended_processes

  placement_group     = var.placement_group
  metrics_granularity = var.metrics_granularity
  enabled_metrics     = var.enabled_metrics



  wait_for_capacity_timeout = var.wait_for_capacity_timeout

  min_elb_capacity        = var.min_elb_capacity
  wait_for_elb_capacity   = var.wait_for_elb_capacity
  protect_from_scale_in   = var.protect_from_scale_in
  service_linked_role_arn = var.service_linked_role_arn
  max_instance_lifetime   = var.max_instance_lifetime



  dynamic "tag" {
    for_each = local.tags
    content {
      key                 = tag.value["key"]
      value               = tag.value["value"]
      propagate_at_launch = tag.value["propagate_at_launch"]
    }
  }

  lifecycle {
    create_before_destroy = true
    ignore_changes = [
      tags,
    ]
  }
}
