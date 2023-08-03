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
  }

  tags = merge(
    local.common_tags
    # var.tags
  )
}
