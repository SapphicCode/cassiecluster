resource "aws_iam_user" "rclone" {
  name = "cassiecluster-rclone"
  path = "/cluster/"
}

resource "aws_iam_user_policy" "rclone_cassie_archive" {
  user = aws_iam_user.rclone.name

  policy = jsonencode({
    Version = "2012-10-17",
    Statement = yamldecode(templatefile(
      "../configs/aws/policies/iam/s3/allow-bucket.yml", { bucket = "cassie-archive*" }
    )),
  })
}

resource "aws_iam_access_key" "rclone" {
  user = aws_iam_user.rclone.name
}

resource "vault_generic_secret" "rclone_glacier" {
  path = "cassiecluster/rclone/glacier"

  data_json = jsonencode({
    type              = "s3",
    provider          = "AWS",
    region            = "eu-north-1",
    storage_class     = "DEEP_ARCHIVE",
    access_key_id     = aws_iam_access_key.rclone.id,
    secret_access_key = aws_iam_access_key.rclone.secret,
  })
}

resource "vault_generic_secret" "rclone_alias_archive_media" {
  path = "cassiecluster/rclone/media-archive"

  data_json = jsonencode({
    type   = "alias",
    remote = format("s3:%s", aws_s3_bucket.archive_media.bucket),
  })
}
