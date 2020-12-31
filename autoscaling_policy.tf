######  AutoScaling Scaling Policy resource for target_tracking

resource "aws_autoscaling_policy" "target_tracking" {
  count = var.enable_autoscaling_group && var.enable_autoscaling_policy && var.policy_type == "TargetTrackingScaling" ? length(var.target_tracking_configuration) : 0
  name  = format("%s-asg-policy", lookup(var.target_tracking_configuration[count.index], "name"))

  autoscaling_group_name = aws_autoscaling_group.this[0].name

  adjustment_type = var.adjustment_type
  policy_type     = var.policy_type
  target_tracking_configuration {
    dynamic "predefined_metric_specification" {
      for_each = length(keys(lookup(var.target_tracking_configuration[count.index], "predefined_metric_specification", {}))) == 0 ? [] : [lookup(var.target_tracking_configuration[count.index], "predefined_metric_specification", {})]
      content {
        predefined_metric_type = lookup(predefined_metric_specification.value, "predefined_metric_type")
        resource_label         = lookup(predefined_metric_specification.value, "resource_label", null)
      }
    }

    dynamic "customized_metric_specification" {
      for_each = length(keys(lookup(var.target_tracking_configuration[count.index], "customized_metric_specification", {}))) == 0 ? [] : [lookup(var.target_tracking_configuration[count.index], "customized_metric_specification", {})]
      content {
        metric_name = lookup(customized_metric_specification.value, "metric_name")
        namespace   = lookup(customized_metric_specification.value, "namespace")
        statistic   = lookup(customized_metric_specification.value, "statistic")
        unit        = lookup(customized_metric_specification.value, "unit", null)
        dynamic "metric_dimension" {
          for_each = length(keys(lookup(customized_metric_specification.value, "metric_dimension", {}))) == 0 ? [] : [lookup(customized_metric_specification.value, "metric_dimension", {})]
          content {
            name  = lookup(metric_dimension.value, "name")
            value = lookup(metric_dimension.value, "value")
          }
        }
      }
    }
    target_value     = lookup(var.target_tracking_configuration[count.index], "target_value")
    disable_scale_in = lookup(var.target_tracking_configuration[count.index], "disable_scale_in", false)
  }
}

######### Simple Scaling ###########

resource "aws_autoscaling_policy" "simple_scaling" {
  count = var.enable_autoscaling_group && var.enable_autoscaling_policy && var.policy_type == "SimpleScaling" ? 1 : 0
  name  = format("%s-asg-policy-%d", var.name, count.index)

  autoscaling_group_name = aws_autoscaling_group.this[0].name

  adjustment_type = var.adjustment_type
  policy_type     = var.policy_type
  # estimated_instance_warmup = var.estimated_instance_warmup
  ### For SimpleScaling
  min_adjustment_magnitude = var.policy_type == "SimpleScaling" && var.adjustment_type == "PercentChangeInCapacity" ? var.min_adjustment_magnitude : null
  cooldown                 = var.policy_type == "SimpleScaling" ? var.cooldown : null
  scaling_adjustment       = var.policy_type == "SimpleScaling" ? var.scaling_adjustment : null
}
