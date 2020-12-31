output "launch_configuration_id" {
  description = "The ID of the launch configuration"
  value       = aws_launch_configuration.this.*.id
}

output "launch_configuration_name" {
  description = "The name of the launch configuration"
  value       = aws_launch_configuration.this.*.name
}

output "launch_configuration_arn" {
  description = "The name of the launch configuration"
  value       = aws_launch_configuration.this.*.name
}

output "asg_id" {
  description = "The autoscaling group id"
  value       = aws_autoscaling_group.this.*.id
}
output "asg_arn" {
  description = "The ARN for this AutoScaling Group"
  value       = aws_autoscaling_group.this.*.arn
}

output "sg_id" {
  description = "The ID of the security group"
  value       = aws_security_group.this.*.id
}

output "sg_arn" {
  description = "The ID of the security group"
  value       = aws_security_group.this.*.arn
}

output "asg_target_tracking_policy_arns" {
  description = "The ARN assigned by AWS to the scaling policy."
  value       = aws_autoscaling_policy.target_tracking.*.arn
}

output "asg_simple_scaling_policy_arn" {
  description = "The ARN assigned by AWS to the scaling policy."
  value       = aws_autoscaling_policy.simple_scaling.*.arn
}

output "asg_target_tracking_policy_names" {
  description = "The scaling policy's name."
  value       = aws_autoscaling_policy.target_tracking.*.name
}

output "asg_simple_scaling_policy_names" {
  description = "The scaling policy's name."
  value       = aws_autoscaling_policy.simple_scaling.*.name
}

output "asg_target_tracking_policy_adjustment_types" {
  description = "The scaling policy's adjustment type."
  value       = aws_autoscaling_policy.target_tracking.*.adjustment_type
}

output "asg_simple_scaling_policy_adjustment_type" {
  description = "The scaling policy's adjustment type."
  value       = aws_autoscaling_policy.simple_scaling.*.adjustment_type
}

output "asg_target_tracking_policys" {
  description = "The scaling policy's type."
  value       = aws_autoscaling_policy.target_tracking.*.policy_type
}

output "asg_simple_scaling_policy" {
  description = "The scaling policy's type."
  value       = aws_autoscaling_policy.simple_scaling.*.policy_type
}
