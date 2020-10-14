output "launch_configuration_id" {
  description = "The ID of the launch configuration"
  value       = aws_launch_configuration.instance.id
}

output "launch_configuration_name" {
  description = "The name of the launch configuration"
  value       = aws_launch_configuration.instance.name
}


output "asg_id" {
  description = "The autoscaling group id"
  value       = aws_autoscaling_group.asg.id
}
output "asg_arn" {
  description = "The ARN for this AutoScaling Group"
  value       = aws_autoscaling_group.asg.arn
}
