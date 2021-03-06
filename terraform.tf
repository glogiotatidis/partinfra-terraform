variable "tf-sync-bucket" {}

provider "aws" {
  region = "${var.aws_region}"
}

provider "aws" {
  alias = "us-west-1"
  region = "us-west-1"
}

resource "terraform_remote_state" "s3" {
    backend    = "s3"
    config {
        bucket = "${var.tf-sync-bucket}"
        key    = "network/terraform.tfstate"
        region = "${var.aws_region}"
    }
}

resource "aws_s3_bucket" "partinfra-tfsync" {
    bucket          = "${var.tf-sync-bucket}"
    acl             = "private"
    versioning {
        enabled     = true
    }
    tags {
        Name        = "${var.tf-sync-bucket}"
        Environment = "shared"
    }
}
