# modules/sqs/main.tf

resource "aws_sqs_queue" "app_queue" {
  for_each                  = var.apps

  name                      = format("%s-%s", var.env, each.key)
  delay_seconds             = each.value["delay_seconds"]
  max_message_size          = each.value["max_message_size"]
  message_retention_seconds = each.value["message_retention_seconds"]
  receive_wait_time_seconds = each.value["receive_wait_time_seconds"]
  visibility_timeout_seconds= each.value["visibility_timeout_seconds"]

  tags = merge(
    var.tags
    # each.value["tags"] # need to verify this 
  )
}
