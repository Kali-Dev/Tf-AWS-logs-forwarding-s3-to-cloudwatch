locals {
  common_tags = {
    terraform = "true"
    statefile = "s3://dip-jefe-artifact-storage/envs/prod/sqs.tfstate"
  }
}


module "sqs" {
  source = "../../../modules/sqs"
  env    = "prod"

  # Application list with SQS
  apps = {
    vecms-contact-verifier-error-queue = {
      delay_seconds             = "0"
      max_message_size          = "262144"
      message_retention_seconds = "345600"
      receive_wait_time_seconds = "0"
      visibility_timeout_seconds = "180"
    }

    vecms-contact-verifier-queue = {
      delay_seconds             = "0"
      max_message_size          = "262144"
      message_retention_seconds = "345600"
      receive_wait_time_seconds = "0"
      visibility_timeout_seconds = "180"
    }

    vecms-dmc-d2c-error-queue = {
      delay_seconds             = "0"
      max_message_size          = "262144"
      message_retention_seconds = "345600"
      receive_wait_time_seconds = "0"
      visibility_timeout_seconds = "180"
    }

    vecms-dmc-d2c-queue = {
      delay_seconds             = "0"
      max_message_size          = "262144"
      message_retention_seconds = "345600"
      receive_wait_time_seconds = "0"
      visibility_timeout_seconds = "180"
    }

    views-gal-queue = {
      delay_seconds             = "0"
      max_message_size          = "262144"
      message_retention_seconds = "345600"
      receive_wait_time_seconds = "0"
      visibility_timeout_seconds = "30"
    }

    views-gal-queue-error = {
      delay_seconds             = "0"
      max_message_size          = "262144"
      message_retention_seconds = "345600"
      receive_wait_time_seconds = "0"
      visibility_timeout_seconds = "30"
    }

    "dip-msg-rcvr-prod-deadletter" = {
    delay_seconds             = "0"
    max_message_size          = "262144"
    message_retention_seconds = "345600"
    receive_wait_time_seconds = "0"
    visibility_timeout_seconds= "180"
    fifo_queue                = true
    content_based_deduplication = false
    sqs_managed_sse_enabled   = true
    deduplication_scope       = "messageGroup"
    fifo_throughput_limit     = "perMessageGroupId"
    redrive_policy            = jsonencode({ deadLetterTargetArn = "", maxReceiveCount = 4 }) # Update the deadLetterTargetArn
    policy                    = file("path_to_dip-msg-rcvr-prod-deadletter_policy.json") # Update the path
  }

  "dip-msg-rcvr-qa" = {
    delay_seconds             = "0"
    max_message_size          = "262144"
    message_retention_seconds = "345600"
    receive_wait_time_seconds = "0"
    visibility_timeout_seconds= "180"
    fifo_queue                = true
    content_based_deduplication = true
    sqs_managed_sse_enabled   = true
    deduplication_scope       = "messageGroup"
    fifo_throughput_limit     = "perMessageGroupId"
    redrive_policy            = jsonencode({ deadLetterTargetArn = "arn_of_dip-msg-rcvr-prod-deadletter", maxReceiveCount = 4 }) # Update the deadLetterTargetArn
    policy = file("${path.module}/../policies/dip-msg-rcvr-prod-deadletter_policy.json")
  }

    
  }

  tags = merge(
    local.common_tags
    # var.tags
  )
}
