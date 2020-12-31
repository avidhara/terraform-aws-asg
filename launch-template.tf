resource "aws_launch_template" "this" {
  count = var.enable_launch_template ? 1 : 0

  name        = format("%s-templates", var.name)
  description = format("Launch template for %s", var.name)

  default_version = var.default_version

  dynamic "block_device_mappings" {
    for_each = var.block_device_mappings
    content {
      device_name  = lookup(block_device_mappings.value, "device_name", null)
      no_device    = lookup(block_device_mappings.value, "no_device", null)
      virtual_name = lookup(block_device_mappings.value, "virtual_name", null)

      dynamic "ebs" {
        for_each = flatten(list(lookup(block_device_mappings.value, "ebs", [])))
        content {
          delete_on_termination = lookup(ebs.value, "delete_on_termination", false)
          encrypted             = lookup(ebs.value, "encrypted", null)
          iops                  = lookup(ebs.value, "iops", null)
          kms_key_id            = lookup(ebs.value, "kms_key_id", null)
          snapshot_id           = lookup(ebs.value, "snapshot_id", null)
          volume_size           = lookup(ebs.value, "volume_size", null)
          volume_type           = lookup(ebs.value, "volume_type", null)
        }
      }
    }
  }
  # checkov:skip=CKV_AWS_79:This needs to be addressed
  # dynamic "metadata_options " {
  #   for_each = var.metadata_options
  #   content {
  #     http_endpoint               = lookup(metadata_options.value, "http_endpoint", "enabled")
  #     http_tokens                 = lookup(metadata_options.value, "http_tokens", "optional")
  #     http_put_response_hop_limit = lookup(metadata_options.value, "http_put_response_hop_limit", "1")
  #   }
  # }

  dynamic "credit_specification" {
    for_each = var.credit_specification != null ? [var.credit_specification] : []
    content {
      cpu_credits = lookup(credit_specification.value, "cpu_credits", "standard")
    }
  }

  disable_api_termination = var.disable_api_termination
  ebs_optimized           = var.ebs_optimized

  image_id                             = var.image_id
  instance_initiated_shutdown_behavior = var.instance_initiated_shutdown_behavior

  instance_type = var.instance_type
  key_name      = var.key_name

  user_data = var.user_data == null ? var.user_data_base64 : base64encode(var.user_data)

  iam_instance_profile {
    name = var.iam_instance_profile
  }

  monitoring {
    enabled = var.enable_monitoring
  }

  #    Need to work on this
  #   network_interfaces {
  #     description                 = "ENI for ${var.name}"
  #     device_index                = 0
  #     associate_public_ip_address = var.associate_public_ip_address
  #     delete_on_termination       = true
  #     security_groups             = length(var.security_groups) <= 0 && var.vpc_id != "" ? aws_security_group.this.*.id : var.security_groups
  #   }

  vpc_security_group_ids = length(var.security_groups) <= 0 && var.vpc_id != "" ? aws_security_group.this.*.id : var.security_groups
  tag_specifications {
    resource_type = "volume"
    tags          = var.tags
  }

  tag_specifications {
    resource_type = "instance"
    tags          = var.tags
  }

  tags = var.tags

  lifecycle {
    create_before_destroy = true
  }
}
