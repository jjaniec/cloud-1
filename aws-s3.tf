resource "aws_s3_bucket" "static" {
  bucket = "${var.naming.name}-static"
  acl    = "private"

  tags = var.naming.tags
}

resource "aws_s3_bucket_object" "cwlogs-config" {
  bucket         = aws_s3_bucket.static.bucket
  key            = "awslogs.conf"
  content_base64 = "${base64encode(data.template_file.awslogs-conf.rendered)}"
  etag           = "${md5(data.template_file.awslogs-conf.template)}"
}

data "aws_iam_policy_document" "s3_policy" {
  statement {
    actions   = ["s3:GetObject"]
    resources = ["${aws_s3_bucket.static.arn}/*"]

    principals {
      type        = "AWS"
      identifiers = [aws_cloudfront_origin_access_identity.origin_access_identity.iam_arn]
    }
  }

  statement {
    actions   = ["s3:ListBucket"]
    resources = [aws_s3_bucket.static.arn]

    principals {
      type        = "AWS"
      identifiers = [aws_cloudfront_origin_access_identity.origin_access_identity.iam_arn]
    }
  }
}

resource "aws_s3_bucket_policy" "static" {
  bucket = aws_s3_bucket.static.id
  policy = data.aws_iam_policy_document.s3_policy.json
}
