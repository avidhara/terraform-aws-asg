resource "aws_iam_service_linked_role" "autoscaling" {
  aws_service_name = "autoscaling.amazonaws.com"
  description      = "A service linked role for autoscaling"
  custom_suffix    = "something"

  # Sometimes good sleep is required to have some IAM resources created before they can be used
  provisioner "local-exec" {
    command = "sleep 10"
  }
}

module "asg_1" {
  source = "../../"
  name   = "example"

  block_device_mappings = [
    {
      device_name = "/dev/xvda"
      ebs = {
        volume_size = 20
        volume_type = "gp2"
      }
    }
  ]
  image_id      = "ami-0947d2ba12ee1ff75"
  instance_type = "t2.micro"
  key_name      = "test"
  user_data     = file("${path.module}/install.sh")

  ### ASG
  enable_autoscaling_group  = true
  vpc_zone_identifier       = var.vpc_zone_identifier
  security_groups           = var.security_groups
  min_size                  = 0
  max_size                  = 1
  desired_capacity          = 1
  wait_for_capacity_timeout = 0
  service_linked_role_arn   = aws_iam_service_linked_role.autoscaling.arn

  initial_lifecycle_hook = [
    {
      name                 = "example-initial-lifecyclehook"
      default_result       = "CONTINUE"
      heartbeat_timeout    = "500"
      lifecycle_transition = "autoscaling:EC2_INSTANCE_LAUNCHING"
    }
  ]
  enable_autoscaling_policy = true
  adjustment_type           = "ExactCapacity"
  policy_type               = "TargetTrackingScaling"
  target_tracking_configuration = [
    {
      name         = "cpu-util"
      target_value = "40.0"
      predefined_metric_specification = {
        predefined_metric_type = "ASGAverageCPUUtilization"
      }
    },
    {
      name         = "avg-network-in"
      target_value = "100"
      predefined_metric_specification = {
        predefined_metric_type = "ASGAverageNetworkIn"
      }
    },
    {
      customized_metric_specification = {
        metric_name = "DiskWriteOps"
        namespace   = "EC2"
        statistic   = "Average"
        metric_dimension = {
          name  = "InstanceId"
          value = "i-01928125cb2fe3448"
        }
      }
      name         = "custom-1"
      target_value = "40"
    }
  ]
  
  ###### Tags

  tags = {
    Tier        = "Application"
    Allocation  = "example"
    Environment = "Exploratory"
    owner       = "cpe"
    project-id  = "0000"
    cost-center = "00000"
    app         = "testing"

  }
}
