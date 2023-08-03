resource "aws_sqs_queue_policy" "queue_policy" {
  for_each = var.apps

  queue_url = aws_sqs_queue.app_queue[each.key].url
  policy    = each.value["policy"]
}
