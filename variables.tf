variable "naming" {
  type = object({
    name          = string,
    tags          = map(string)
  })
}


variable "instance_type" {
  default = "t2.micro"
}

variable "rds_instance_type" {
  default = "db.t2.micro"
}


variable "subnets_az" {
	type = list(string)
	default = ["eu-west-1a", "eu-west-1b", "eu-west-1c"]
}

variable "pub_subnet_cidrs" {
	type = list(string)
	default = ["10.0.1.0/24", "10.0.2.0/24", "10.0.3.0/24"]
}

variable "priv_subnet_cidrs" {
	type = list(string)
	default = ["10.0.10.0/24", "10.0.20.0/24", "10.0.30.0/24"]
}

variable "mysql_config" {
  type = object({
    username = string,
    password = string,
    port = string
  })
  default = {
    username: "user",
    password: "password",
    port: 3306
  }
}
