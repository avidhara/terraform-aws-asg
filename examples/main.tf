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
  source        = "../"
  name          = "example"
  image_id      = "ami-01fee56b22f308154"
  instance_type = "t2.micro"
  key_name      = "test"
  user_data     = file("${path.module}/install.sh")
  root_block_device = [
    {
      volume_size           = "25"
      volume_type           = "gp2"
      delete_on_termination = true
      encrypted             = true

    },
  ]

  vpc_id                    = var.vpc_id
  ingress                   = var.ingress
  egress                    = var.egress
  vpc_zone_identifier       = var.vpc_zone_identifier
  min_size                  = 0
  max_size                  = 1
  desired_capacity          = 1
  wait_for_capacity_timeout = 0
  service_linked_role_arn   = aws_iam_service_linked_role.autoscaling.arn
  tags = {
    extra_tag1 = "extra_value1"
    extra_tag2 = "extra_value2"
  }
}
