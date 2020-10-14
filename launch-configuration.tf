resource "aws_launch_configuration" "this" {
  name                        = var.name
  image_id                    = var.image_id
  instance_type               = var.instance_type
  iam_instance_profile        = var.iam_instance_profile
  key_name                    = var.key_name
  security_groups             = length(var.security_groups) <= 0 && var.vpc_id != "" ? aws_security_group.this.*.id : var.security_groups
  associate_public_ip_address = var.associate_public_ip_address
  enable_monitoring           = var.enable_monitoring
  ebs_optimized               = var.ebs_optimized

  user_data        = var.user_data
  user_data_base64 = var.user_data_base64


  dynamic "root_block_device" {
    for_each = var.root_block_device
    content {
      delete_on_termination = lookup(root_block_device.value, "delete_on_termination", null)
      encrypted             = lookup(root_block_device.value, "encrypted", null)
      iops                  = lookup(root_block_device.value, "iops", null)
      # kms_key_id            = lookup(root_block_device.value, "kms_key_id", null)
      volume_size = lookup(root_block_device.value, "volume_size", null)
      volume_type = lookup(root_block_device.value, "volume_type", null)
    }
  }


  placement_tenancy = var.placement_tenancy
  lifecycle {
    ## Can't create 2 Launch configs with same name
    # create_before_destroy = true
    ignore_changes = [
      # Ignore changes to key_name, e.g. because a management agent
      # updates these based on some ruleset managed elsewhere.
      name,
      key_name,
      root_block_device,
    ]
  }
}
