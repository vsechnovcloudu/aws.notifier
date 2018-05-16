terraform {
  backend "s3" {
    bucket = "vvc.aws.notifier.ops"
    key    = "terraform.tfstate"
    region = "eu-west-1"
  }
}
