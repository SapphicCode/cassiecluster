resource "aws_iam_user" "cassandra" {
  name = "Cassandra"
  path = "/user/"
}

resource "aws_iam_user_policy" "cassandra_s3" {
  user = aws_iam_user.cassandra.name

  policy = jsonencode({
    Version = "2012-10-17",
    Statement = concat(
      yamldecode(file("../configs/aws/policies/iam-s3-list-buckets.yml")),
      yamldecode(templatefile("../configs/aws/policies/iam-s3-allow-bucket.yml", { bucket = "cassie-*" })),
    ),
  })
}
