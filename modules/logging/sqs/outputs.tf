output "sqs_apps" {
  value = aws_sqs_queue.app_queue[*].id
}
