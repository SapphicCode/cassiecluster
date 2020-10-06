provider "aws" {
  region = "eu-north-1"
}

variable "static_sites" {
  type = list(string)
  default = [
    "meta.qcx.io",
    "cassandra.beelen.one"
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
  bucket = aws_s3_bucket.static_site[count.index].bucket
  policy = jsonencode(yamldecode(templatefile(
    "../configs/aws/policies/s3-cloudflare.yml",
    { bucket = aws_s3_bucket.static_site[count.index].bucket }
  )))

  count = length(aws_s3_bucket.static_site)
}