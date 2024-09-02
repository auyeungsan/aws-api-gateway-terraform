provider "aws" {
    region = "ap-southeast-1"
    profile = "test-dev"
}

terraform {
    backend "s3" {
        profile         = "test-dev"
        encrypt         = true
        bucket          = "test-dev-terraform-state"
        dynamodb_table  = "test-dev-terraform-state-lock-dynamo"
        region          = "ap-southeast-1"
        key             = "dev/vpc/starrise-dev-clustervpc-v1"
    }
}
