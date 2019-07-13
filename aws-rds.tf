resource "aws_db_instance" "back" {
  allocated_storage      = 10
  storage_type           = "gp2"
  engine                 = "mysql"
  engine_version         = "5.7"
  instance_class         = var.rds_instance_type
  name                   = var.mysql_config["database"]
  username               = var.mysql_config["username"]
  password               = var.mysql_config["password"]
  parameter_group_name   = "default.mysql5.7"
  port                   = var.mysql_config["port"]
  vpc_security_group_ids = [aws_security_group.back.id]
  db_subnet_group_name   = aws_db_subnet_group.back.name
  skip_final_snapshot    = true
}

resource "aws_db_subnet_group" "back" {
  name       = "cloud1dbsubnetgroup"
  subnet_ids = aws_subnet.priv[*].id

  tags = var.naming.tags
}
