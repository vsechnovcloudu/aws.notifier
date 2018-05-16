terraform {
  backend "s3" {
    bucket = "vvc.aws.notifier.operations"
    key    = "terraform.tfstate"
    region = "eu-west-1"
  }
}
