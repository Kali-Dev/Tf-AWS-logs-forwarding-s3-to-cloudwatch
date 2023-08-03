provider "aws" {
  region = "us-gov-west-1"
}

terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 4.47.0"
    }
  }
}

backend "s3" {
  bucket  = "dip-jefe-artifact-storage"
  key     = "envs/prod/sqs.tfstate"
  region  = "us-gov-west-1"
  encrypt = true
}
