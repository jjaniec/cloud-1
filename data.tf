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
    db_name     = var.mysql_config["database"]
    db_host     = aws_db_instance.back.endpoint
    db_user     = var.mysql_config["username"]
    db_password = var.mysql_config["password"]
  }
}
