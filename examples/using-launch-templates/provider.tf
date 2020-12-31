provider "aws" {
  version                 = "> 2.14.0"
  region                  = "us-west-2"
  shared_credentials_file = pathexpand("~/.aws/credentials")
  profile                 = "default"
}