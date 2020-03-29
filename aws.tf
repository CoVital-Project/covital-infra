provider "aws" {
  version = "~> 2.55"

  region = "eu-west-1"
}

resource "aws_s3_bucket" "videos-sandbox" {
  bucket = "covital-video-sandbox"
  acl    = "public-read"

  tags = {
    Name        = "covital video sandbox bucket"
    Environment = "sandbox"
    Owner       = "covital backend engineering"
    ManagedBy   = "covital-infra terraform repo"
  }
}

resource "aws_s3_bucket" "videos-staging" {
  bucket = "covital-video-staging"
  acl    = "public-read-write"

  tags = {
    Name        = "covital video staging bucket"
    Environment = "staging"
    Owner       = "covital backend engineering"
    ManagedBy   = "covital-infra terraform repo"
  }
}

##### TERRAFORM STATE TRACKING #########

resource "aws_s3_bucket" "terraform-state" {
  bucket = "covital-terraform-state"
  acl    = "private"

  tags = {
    Name        = "covital terraform state bucket"
    Environment = "sandbox"
    Owner       = "covital backend engineering"
    ManagedBy   = "covital-infra terraform repo"
  }
}

# create a dynamodb table for locking the state file
resource "aws_dynamodb_table" "dynamodb-terraform-state-lock" {
  name           = "terraform-state-lock-dynamo"
  hash_key       = "LockID"
  read_capacity  = 20
  write_capacity = 20

  attribute {
    name = "LockID"
    type = "S"
  }

  tags = {
    Name      = "DynamoDB Terraform State Lock Table"
    Owner     = "covital backend engineering"
    ManagedBy = "covital-infra terraform repo"
  }
}
