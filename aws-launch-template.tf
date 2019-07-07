resource "aws_launch_template" "front" {
  name = "${var.naming.name}-wp"
  description = "${var.naming.name} launch template for asg"
  vpc_security_group_ids = [
    aws_security_group.front.id
  ]

  # instance_initiated_shutdown_behavior = "terminate"
  image_id = data.aws_ami.amazonlinux.id
  instance_type = var.instance_type
  key_name = "DefaultKPIreland"
  user_data = base64encode(data.template_file.wp.rendered)

  iam_instance_profile {
    name = aws_iam_instance_profile.front.id
  }

  lifecycle  {
    create_before_destroy = true
  }

  tags = var.naming.tags
}
