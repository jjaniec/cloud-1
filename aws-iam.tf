
resource "aws_iam_instance_profile" "front" {
  name = "${var.naming.name}-front"
  role = aws_iam_role.front.name
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
