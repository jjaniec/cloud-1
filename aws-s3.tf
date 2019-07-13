resource "aws_s3_bucket_object" "cwlogs-config" {
  bucket         = aws_s3_bucket.logs.bucket
  key            = "awslogs.conf"
  content_base64 = "${base64encode(data.template_file.awslogs-conf.rendered)}"
  etag           = "${md5(data.template_file.awslogs-conf.template)}"
}

resource "aws_s3_bucket" "logs" {
  bucket = "${var.naming.name}-cwlogs-config"
  acl    = "private"

  tags = var.naming.tags
}
