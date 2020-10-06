terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 3.0"
    }
  }
}

provider "aws" {
  region = "eu-north-1"
}

variable "static_sites" {
  type = list(string)
  default = [
    "meta.qcx.io",
    "cassandra.beelen.one",
    "testbucket.qcx.io"
  ]
}

resource "aws_s3_bucket" "static_site" {
  bucket = var.static_sites[count.index]

  website {
    error_document = "404.html"
    index_document = "index.html"
  }

  count = length(var.static_sites)
}

resource "aws_s3_bucket_policy" "static_site" {
  bucket = var.static_sites[count.index]
  policy = jsonencode(yamldecode(templatefile("../configs/aws/policies/s3-cloudflare.yml", { bucket = var.static_sites[count.index] })))

  count = length(var.static_sites)
}
