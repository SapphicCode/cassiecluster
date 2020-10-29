resource "aws_iam_user" "rclone" {
  name = "cassiecluster-rclone"
  path = "/cluster/"
}

resource "aws_iam_user_policy" "rclone-cassie-archive" {
  user = aws_iam_user.rclone.name

  policy = jsonencode({
    Version = "2012-10-17",
    Statement = yamldecode(templatefile(
      "../configs/aws/policies/iam-s3-allow-bucket.yml", { bucket = "cassie-archive*" }
    )),
  })
}

resource "aws_iam_access_key" "rclone" {
  user = aws_iam_user.rclone.name
}

resource "vault_generic_secret" "rclone" {
  path = "cassiecluster/rclone/aws"

  data_json = jsonencode({
    access_key_id = aws_iam_access_key.rclone.id,
    secret_key    = aws_iam_access_key.rclone.secret,
  })
}
