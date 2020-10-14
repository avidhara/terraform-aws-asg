# Terraform Module for AWS Auto Scaling Group

### Use as a Module

```terrraform
module "asg_1"{
    source = "./"
    name = var.launch_config_name
    image_id = var.ami
    instance_type = var.instance_type
    iam_instance_profile = var.iam_instance_profile
    key_name = var.key_name
    security_groups = module.sg.ids
    user_data = var.user_data
    root_block_device = var.root_block_device
    ### FOR ASG ####
    max_size = var.max_size
    min_size = var.min_size
    desired_capacity = var.desired_capacity
    vpc_zone_identifier = module.vpc.private_subnet_ids
    additional_tags = var.additional_tags

}
```
<!-- BEGINNING OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
## Requirements

| Name | Version |
|------|---------|
| terraform | ~> 0.12.24 |
| aws | ~> 2.60 |

## Providers

| Name | Version |
|------|---------|
| aws | ~> 2.60 |
| null | n/a |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| additional\_tags | n/a | `map(string)` | <pre>{<br>  "createdby": "devops"<br>}</pre> | no |
| associate\_public\_ip\_address | Associate a public ip address with an instance in a VPC. | `bool` | `false` | no |
| default\_cooldown | The amount of time, in seconds, after a scaling activity completes before another scaling activity can start. | `number` | `30` | no |
| desired\_capacity | The number of Amazon EC2 instances that should be running in the group | `number` | `"1"` | no |
| ebs\_optimized | If true, the launched EC2 instance will be EBS-optimized | `bool` | `false` | no |
| enable\_monitoring | Enables/disables detailed monitoring. This is enabled by default. | `bool` | `false` | no |
| enabled\_metrics | A list of metrics to collect | `list(string)` | <pre>[<br>  "GroupMinSize",<br>  "GroupMaxSize",<br>  "GroupDesiredCapacity",<br>  "GroupInServiceInstances",<br>  "GroupPendingInstances",<br>  "GroupStandbyInstances",<br>  "GroupTerminatingInstances",<br>  "GroupTotalInstances"<br>]</pre> | no |
| health\_check\_grace\_period | Time (in seconds) after instance comes into service before checking health. | `number` | `300` | no |
| health\_check\_type | EC2 or ELB, Controls how health checking is done. | `string` | `"EC2"` | no |
| iam\_instance\_profile | The name attribute of the IAM instance profile to associate with launched instances. | `string` | `null` | no |
| image\_id | The EC2 image ID to launch | `string` | `null` | no |
| instance\_type | The size of instance to launch | `string` | `null` | no |
| key\_name | The key name that should be used for the instance | `string` | `null` | no |
| max\_size | The maximum size of the auto scale group | `number` | `"3"` | no |
| metrics\_granularity | The granularity to associate with the metrics to collect | `string` | `"1Minute"` | no |
| min\_size | The minimum size of the auto scale group | `number` | `"1"` | no |
| name | The name of the launch configuration. If you leave this blank, Terraform will auto-generate a unique name | `string` | `null` | no |
| placement\_group | The name of the placement group into which you'll launch your instances, if any | `string` | `null` | no |
| placement\_tenancy | The tenancy of the instance. Valid values are default or dedicated | `string` | `"default"` | no |
| root\_block\_device | Customize details about the root block device of the instance | `list(map(string))` | <pre>[<br>  {<br>    "volume_size": "20",<br>    "volume_type": "gp2"<br>  }<br>]</pre> | no |
| security\_groups | A list of associated security group IDS. | `list` | `[]` | no |
| suspended\_processes | A list of processes to suspend for the AutoScaling Group | `list(string)` | <pre>[<br>  "ReplaceUnhealthy",<br>  "HealthCheck"<br>]</pre> | no |
| termination\_policies | A list of policies to decide how the instances in the auto scale group should be terminated | `list(string)` | <pre>[<br>  "NewestInstance",<br>  "Default"<br>]</pre> | no |
| user\_data | The user data to provide when launching the instance. Do not pass gzip-compressed data via this argument | `string` | `null` | no |
| user\_data\_base64 | Can be used instead of user\_data to pass base64-encoded binary data directly | `string` | `null` | no |
| vpc\_zone\_identifier | A list of subnet IDs to launch resources in | `list(string)` | `[]` | no |
| wait\_for\_capacity\_timeout | A maximum duration that Terraform should wait for ASG instances to be healthy before timing out. | `number` | `0` | no |

## Outputs

| Name | Description |
|------|-------------|
| asg\_arn | The ARN for this AutoScaling Group |
| asg\_id | The autoscaling group id |
| launch\_configuration\_id | The ID of the launch configuration |
| launch\_configuration\_name | The name of the launch configuration |

<!-- END OF PRE-COMMIT-TERRAFORM DOCS HOOK -->

### ToDo

- [ ] Add Scaling policies
- [ ] Add Lifecycle Hooks
- [ ] Add Scheduled Actions
