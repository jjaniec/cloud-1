
resource "aws_iam_instance_profile" "front" {
  name = "${var.naming.name}-front"
  role = aws_iam_role.front.name
}

resource "aws_iam_role_policy" "cw-logs-publish" {
  # description = "Allow fetching cw logs config file & pushing to cw logs"
  name = "${var.naming.name}-cwlogs-access"
  role = aws_iam_role.front.name

  policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Action": [
          "logs:CreateLogGroup",
          "logs:CreateLogStream",
          "logs:PutLogEvents",
          "logs:DescribeLogStreams"
      ],
      "Resource": [
          "arn:aws:logs:*:*:*"
      ]
    },
    {
      "Effect": "Allow",
      "Action": [
          "s3:*"
      ],
      "Resource": [
          "${aws_s3_bucket.static.arn}",
          "${aws_s3_bucket.static.arn}/*"
      ]
    }
  ]
}
EOF
}


resource "aws_iam_role" "front" {
  name = "${var.naming.name}-front"

  assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": "sts:AssumeRole",
      "Principal": {
        "Service": "ec2.amazonaws.com"
      },
      "Effect": "Allow"
    }
  ]
}
EOF
}
