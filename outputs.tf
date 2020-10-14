output "launch_configuration_id" {
  description = "The ID of the launch configuration"
  value       = aws_launch_configuration.this.id
}

output "launch_configuration_name" {
  description = "The name of the launch configuration"
  value       = aws_launch_configuration.this.name
}

output "launch_configuration_arn" {
  description = "The name of the launch configuration"
  value       = aws_launch_configuration.this.name
}

output "asg_id" {
  description = "The autoscaling group id"
  value       = aws_autoscaling_group.this.id
}
output "asg_arn" {
  description = "The ARN for this AutoScaling Group"
  value       = aws_autoscaling_group.this.arn
}

output "sg_id" {
  description = "The ID of the security group"
  value       = aws_security_group.this.*.id
}

output "sg_arn" {
  description = "The ID of the security group"
  value       = aws_security_group.this.*.arn
}
