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
    current_region              = data.aws_region.current.name
    awslogs_conf_bucket         = aws_s3_bucket.static.bucket
    awslogs_conf_key            = aws_s3_bucket_object.cwlogs-config.key
    db_name                     = var.mysql_config["database"]
    db_host                     = aws_db_instance.back.address
    db_user                     = var.mysql_config["username"]
    db_password                 = var.mysql_config["password"]
    site_title                  = var.naming.name
    wp_admin_user               = "root"
    wp_admin_password           = "toor"
    wp_admin_email              = "admin@${var.naming.name}.com"
    wp_url                      = aws_lb.front.dns_name
    wp_plugin_configs           = data.template_file.wp-plugin-configs.rendered
    static_content_bucket       = aws_s3_bucket.static.bucket
    cloudfront_distribution_dns = aws_cloudfront_distribution.main.domain_name
    static_content_key_prefix   = "static"
  }
}

data "template_file" "wp-plugin-configs" {
  template = "${file("${path.module}/user-data/init-plugins.txt")}"

  vars = {
    current_region              = data.aws_region.current.name
    db_name                     = var.mysql_config["database"]
    db_host                     = aws_db_instance.back.address
    db_user                     = var.mysql_config["username"]
    db_password                 = var.mysql_config["password"]
    static_content_bucket       = aws_s3_bucket.static.bucket
    cloudfront_distribution_dns = aws_cloudfront_distribution.main.domain_name
    static_content_key_prefix   = "wp-content/uploads"
  }
}

data "template_file" "awslogs-conf" {
  template = "${file("${path.module}/awslogs.conf")}"
}