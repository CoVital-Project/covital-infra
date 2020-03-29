# Covital terraform configs

## Contents

### Root folder
- aws configs. do not push changes unless the `terraform plan` is clean (i.e. you have verified it works and applied it from your local machhine).
  - includes an s3+dynamo pair for terraform remote state backend
  - includes two s3 buckets intended for video upload by our mobile apps.

### Auth0 folder
- work in progress to sketch out an auth0 story for our backend web service

## TODO:
- add heroku configs for our existing setup
- improve our AWS security model

## HOWTO use this config setup:
- install terraform 0.12.24 as required in `base.tf`
- set all of the environment variables described in [.env.example](.env.example) in order to grant terraform API access to the services we're managing
- `terraform init` to download all of the required tf modules and connect to our aws-hosted terraform state
- `terraform plan -input=false -out=tf.plan` has terraform connect to each API and see whether or not the detected state of our infrastructure matches the locally described configurations
- `terraform apply tf.plan` will execute the plan and attempt to bring the real world into compliance with the described plan

## Where to get help?
contact dpritchett, cj russell, or dave hagman on slack
