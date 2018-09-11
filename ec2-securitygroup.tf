###### EC2 Instance SG
resource "aws_security_group" "ecs_securitygroup" {
  vpc_id      = "${data.terraform_remote_state.vpc.vpc_id}"
  name        = "SG-${var.environment_name}-ec2"
  description = "Security group for ${var.environment_name} ECS instances"

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
  ingress {
    from_port       = 80
    to_port         = 80
    protocol        = "tcp"
    security_groups = ["${aws_security_group.lb_securitygroup.id}"]
  }
  ingress {
    from_port       = 22
    to_port         = 22
    protocol        = "tcp"
    cidr_blocks     = ["0.0.0.0/0"]
  }
  ingress {
    from_port       = 80
    to_port         = 80
    protocol        = "tcp"
    cidr_blocks     = ["0.0.0.0/0"]
  }
  ingress {
    from_port       = 19999
    to_port         = 19999
    protocol        = "tcp"
    cidr_blocks     = ["0.0.0.0/0"]
    description     = "NetData"
  }
    ingress {
    from_port       = 8080  
    to_port         = 8080
    protocol        = "tcp"
    cidr_blocks     = ["0.0.0.0/0"]
    description     = "cAdvisor"
  }
    ingress {
    from_port       = 9100
    to_port         = 9100
    protocol        = "tcp"
    cidr_blocks     = ["0.0.0.0/0"]
    description     = "Node Exporter"
  }
  tags {
    Name = "SG-${var.environment_name}-ec2"
  }
}
###### LOAD BALANCER SG
resource "aws_security_group" "lb_securitygroup" {
  vpc_id      = "${data.terraform_remote_state.vpc.vpc_id}"
  name        = "SG-${var.environment_name}-lb"
  description = "Security group for ${var.environment_name} Load balancer"

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags {
    Name = "SG-${var.environment_name}-lb"
  }
}

###### EFS SG
resource "aws_security_group" "efs_securitygroup" {
  vpc_id      = "${data.terraform_remote_state.vpc.vpc_id}"
  name        = "SG-${var.environment_name}-efs"
  description = "Security group for ${var.environment_name} EFS"

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port       = 2049
    to_port         = 2049
    protocol        = "tcp"
    security_groups = ["${aws_security_group.ecs_securitygroup.id}"]
  }

  tags {
    Name = "SG-${var.environment_name}-efs"
  }
}

###### AURORA SG
resource "aws_security_group" "rds_securitygroup" {
  vpc_id      = "${data.terraform_remote_state.vpc.vpc_id}"
  name        = "SG-${var.environment_name}-rds"
  description = "Security group for RDS"

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port       = 3306
    to_port         = 3306
    protocol        = "tcp"
    security_groups = ["${aws_security_group.ecs_securitygroup.id}"]
  }

  tags {
    Name = "SG-${var.environment_name}-rds"
  }
}