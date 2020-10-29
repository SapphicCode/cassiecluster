locals {
  static_sites = toset([
    "meta.qcx.io",
    "cassandra.beelen.one"
  ])
}

data "http" "cloudflare_ipv4" {
  url = "https://www.cloudflare.com/ips-v4"
}
data "http" "cloudflare_ipv6" {
  url = "https://www.cloudflare.com/ips-v6"
}

resource "aws_s3_bucket" "static_site" {
  bucket = each.key

  tags = {
    type = "static-site"
  }

  website {
    error_document = "404.html"
    index_document = "index.html"
  }

  for_each = local.static_sites
}

resource "aws_s3_bucket_policy" "static_site" {
  bucket = each.value.bucket

  policy = jsonencode(yamldecode(templatefile(
    "../configs/aws/policies/s3/cloudflare.yml",
    {
      bucket = each.value.bucket,
      ips = concat(
        split("\n", trimspace(data.http.cloudflare_ipv4.body)),
        split("\n", trimspace(data.http.cloudflare_ipv6.body)),
      ),
    }
  )))

  for_each = aws_s3_bucket.static_site
}

resource "aws_s3_bucket" "archive" {
  bucket = "cassie-vault"

  tags = {
    type = "archive"
  }

  lifecycle_rule {
    enabled = true

    abort_incomplete_multipart_upload_days = 1
  }

  server_side_encryption_configuration {
    rule {
      apply_server_side_encryption_by_default {
        sse_algorithm = "AES256"
      }
    }
  }

  policy = jsonencode({
    Version = "2012-10-17",
    Statement = concat(
      yamldecode(templatefile("../configs/aws/policies/s3/archive.yml", { bucket = "cassie-vault" }))
    ),
  })
}

resource "aws_s3_bucket" "archive_media" {
  bucket = "cassie-archive-media"

  lifecycle_rule {
    enabled = true

    abort_incomplete_multipart_upload_days = 1
  }

  policy = jsonencode({
    Version = "2012-10-17",
    Statement = concat(
      yamldecode(templatefile("../configs/aws/policies/s3/archive.yml", { bucket = "cassie-archive-media" }))
    ),
  })
}
