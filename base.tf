terraform {
  required_version = "~> 0.12.24"

  backend s3 {
    encrypt        = true
    bucket         = "covital-terraform-state"     # managed in aws.tf
    dynamodb_table = "terraform-state-lock-dynamo" # managed in aws.tf
    region         = "eu-west-1"
    key            = "terraform-states/base/covital-infra/root"
  }
}
