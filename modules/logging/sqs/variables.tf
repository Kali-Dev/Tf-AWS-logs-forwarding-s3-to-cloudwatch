# modules/sqs/variables.tf

variable "env" {
  description = "Environment name"
}

variable "apps" {
  type = map(object({
    delay_seconds             = string
    max_message_size          = string
    message_retention_seconds = string
    receive_wait_time_seconds = string
    visibility_timeout_seconds= string
  }))
  description = "Apps Names"
}

variable "tags" {
  description = "tags"
}
