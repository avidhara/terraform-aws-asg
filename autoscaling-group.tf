resource "null_resource" "tags_as_list_of_maps" {
  count = length(keys(var.additional_tags))

  triggers = {
    "key"                 = keys(var.additional_tags)[count.index]
    "value"               = values(var.additional_tags)[count.index]
    "propagate_at_launch" = "true"
  }
}

resource "aws_autoscaling_group" "asg" {
  name                 = var.name
  launch_configuration = aws_launch_configuration.instance.id

  vpc_zone_identifier = var.vpc_zone_identifier

  health_check_grace_period = var.health_check_grace_period
  health_check_type         = var.health_check_type
  default_cooldown          = var.default_cooldown
  min_size                  = var.min_size
  desired_capacity          = var.desired_capacity
  max_size                  = var.max_size

  suspended_processes       = var.suspended_processes
  wait_for_capacity_timeout = var.wait_for_capacity_timeout

  metrics_granularity = var.metrics_granularity
  enabled_metrics     = var.enabled_metrics
  placement_group     = var.placement_group
  tags = concat(
    [
      {
        key                 = "Name"
        value               = var.name
        propagate_at_launch = true
      }
    ],
    null_resource.tags_as_list_of_maps.*.triggers,
  )
  lifecycle {
    create_before_destroy = true
    ignore_changes = [
      tags,
    ]
  }
}
