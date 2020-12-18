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
