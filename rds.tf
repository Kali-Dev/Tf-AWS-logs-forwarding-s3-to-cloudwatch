variable "db_instance_identifier" {
  description = "List of RDS instance identifiers"
  type        = list(string)
  default     = ["prod-db-1", "prod-db-2"]
}

variable "sns_topic_arn" {
  description = "The ARN of the SNS topic"
  type        = string
  default     = "arn:aws:sns:us-east-1:123456789012:MyTopic"
}

data "aws_db_instance" "example" {
  for_each = toset(var.db_instance_identifier)
  db_instance_identifier = each.key
}

resource "aws_cloudwatch_metric_alarm" "example" {
  for_each = toset(var.db_instance_identifier)

  alarm_name          = "cpu-utilization-${each.key}"
  comparison_operator = "GreaterThanOrEqualToThreshold"
  evaluation_periods  = "2"
  metric_name         = "CPUUtilization"
  namespace           = "AWS/RDS"
  period              = "60"
  statistic           = "Average"
  threshold           = "80"
  alarm_description   = "This metric checks if CPU utilization is greater than 80%"
  alarm_actions       = [var.sns_topic_arn]
  
  dimensions = {
    DBInstanceIdentifier = each.key
  }
}

resource "aws_cloudwatch_metric_alarm" "free_storage_space" {
  for_each = toset(var.db_instance_identifier)

  alarm_name          = "free-storage-space-${each.key}"
  comparison_operator = "LessThanOrEqualToThreshold"
  evaluation_periods  = "2"
  metric_name         = "FreeStorageSpace"
  namespace           = "AWS/RDS"
  period              = "60"
  statistic           = "Average"
  threshold           = "${data.aws_db_instance.example[each.key].allocated_storage * 1024 * 1024 * 1024 * 0.2}" // 20% of total storage
  alarm_description   = "This metric checks if free storage space is less than 20%"
  alarm_actions       = [var.sns_topic_arn]
  
  dimensions = {
    DBInstanceIdentifier = each.key
  }
}
