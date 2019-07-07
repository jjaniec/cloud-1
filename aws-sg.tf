resource "aws_security_group" "alb" {
	name = "${var.naming.name}-alb"
	description = "allow http"
	vpc_id = aws_vpc.main.id

	ingress {
		from_port = 80
		to_port = 80
		protocol = "tcp"
		cidr_blocks = ["0.0.0.0/0"]
	}

	egress {
		from_port = 0
		to_port = 0
		protocol = "-1"
		cidr_blocks = ["0.0.0.0/0"]
	}
}


resource "aws_security_group" "front" {
	name = "${var.naming.name}-front"
	description = "allow http"
	vpc_id = aws_vpc.main.id

	ingress {
		from_port = 80
		to_port = 80
		protocol = "tcp"
		security_groups = [aws_security_group.alb.id]
  }

  ingress {
    protocol    = "tcp"
    from_port   = 32768
    to_port     = 65535
    description = "Allow out service communications"

    security_groups = [
      aws_security_group.alb.id
    ]
  }


	egress {
		from_port = 0
		to_port = 0
		protocol = "tcp"
		cidr_blocks = [aws_vpc.main.cidr_block]
	}
}


resource "aws_security_group" "back" {
	name = "${var.naming.name}-back"
	description = "allow 3306 from front instances"
	vpc_id = aws_vpc.main.id

	ingress {
		from_port = var.mysql_config["port"]
		to_port = var.mysql_config["port"]
		protocol = "tcp"
		security_groups = [aws_security_group.front.id]
  }
}
