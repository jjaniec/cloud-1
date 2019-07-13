data "aws_caller_identity" "current" {}

data "aws_region" "current" {}

data "aws_ami" "amazonlinux" {
  most_recent = true

  filter {
    name   = "name"
    values = ["amzn2-ami-hvm*"]
  }

  filter {
    name   = "architecture"
    values = ["x86_64"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }

  owners = ["amazon"]
}

data "template_file" "wp" {
  template = "${file("${path.module}/user-data/wp.txt")}"

  vars = {
    current_region      = data.aws_region.current.name
    awslogs_conf_bucket = aws_s3_bucket.logs.bucket
    awslogs_conf_key    = aws_s3_bucket_object.cwlogs-config.key
    db_name             = var.mysql_config["database"]
    db_host             = aws_db_instance.back.endpoint
    db_user             = var.mysql_config["username"]
    db_password         = var.mysql_config["password"]
  }
}

data "template_file" "awslogs-conf" {
  template = "${file("${path.module}/awslogs.conf")}"
}
