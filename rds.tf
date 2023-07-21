provider "aws" {
  region = "us-west-2" // Replace with your region
}

data "aws_db_instance" "example1" {
  db_instance_identifier = "mydbinstance1" // Replace with your DB Instance Identifier
}

data "aws_db_instance" "example2" {
  db_instance_identifier = "mydbinstance2" // Replace with your DB Instance Identifier
}

locals {
  common_alarm_config = {
    evaluation_periods  = "2"
    period              = "120"
    statistic           = "Average"
    alarm_description   = "CloudWatch alarm triggered."
    alarm_actions       = ["arn:aws:sns:us-west-2:111122223333:my-topic"] // Replace with your SNS Topic ARN
  }

  instances = {
    "example1" = data.aws_db_instance.example1
    "example2" = data.aws_db_instance.example2
  }

  alarms = {
    cpu_utilization = {
      metric        = "CPUUtilization"
      operator      = "GreaterThanOrEqualToThreshold"
      threshold     = "70"
    }

    free_storage_space = {
      metric        = "FreeStorageSpace"
      operator      = "LessThanOrEqualToThreshold"
      threshold     = 1024 * 1024 * 1024 * 20 // 20 GB
    }

    freeable_memory = {
      metric        = "FreeableMemory"
      operator      = "LessThanOrEqualToThreshold"
      threshold     = data.aws_db_instance.example1.db_instance_class * 1024 * 1024 * 1024 * 0.20 // 20% of instance's total memory
    }
  }
}

resource "aws_cloudwatch_metric_alarm" "alarm" {
  for_each = { for k, v in local.instances : k => v }

  alarm_name          = "${each.key}-${lookup(local.alarms[each.key], "metric", "")}-alarm"
  comparison_operator = lookup(local.alarms[each.key], "operator", "")
  metric_name         = lookup(local.alarms[each.key], "metric", "")
  namespace           = "AWS/RDS"
  threshold           = lookup(local.alarms[each.key], "threshold", "")
  dimensions = {
    DBInstanceIdentifier = each.value.db_instance_identifier
  }
  dynamic "alarm_description" {
    for_each = local.common_alarm_config
    content {
      alarm_description = alarm_description.value
    }
  }
  dynamic "alarm_actions" {
    for_each = local.common_alarm_config
    content {
      alarm_actions = alarm_actions.value
    }
  }
}
