
terraform {
  backend "s3" {
    bucket         = "jenkins-bucket-9202"
    dynamodb_table = "terraform-state-lock-dynamo"
    key            = "remote.tfstate"
    region         = "us-east-1"
  }
}