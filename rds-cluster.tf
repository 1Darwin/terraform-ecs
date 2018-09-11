
resource "aws_db_subnet_group" "aurora" {
    name       = "${var.environment_name}"
    subnet_ids = ["${split(",", data.terraform_remote_state.vpc.private_subnets)}"]

    tags {
        Name = "${var.environment_name}"
        ENV  = "TAG"
    }
}
resource "aws_rds_cluster" "aurora" {
    cluster_identifier        = "${var.environment_name}"
    engine                    = "aurora-mysql"
    engine_version            = "5.7.12"
    availability_zones        = ["${split(",", data.terraform_remote_state.vpc.azs)}"]
    db_subnet_group_name      = "${aws_db_subnet_group.aurora.id}"
    vpc_security_group_ids    = ["${aws_security_group.rds_securitygroup.id}"]
    database_name             = "${var.rds_db_default_name}"
    master_username           = "${var.rds_master_username}"
    master_password           = "${var.rds_master_password}"
    backup_retention_period   = 7
    preferred_backup_window   = "02:00-03:00"
    skip_final_snapshot       = true
    final_snapshot_identifier = "${var.environment_name}-final"
    tags {
        Name = "${var.environment_name}"
        ENV  = "TAG"
    }
    lifecycle {
        ignore_changes = ["master_password", "availability_zones"]
    }
}

resource "aws_rds_cluster_instance" "aurora" {
    count                   = 1
    identifier              = "${var.environment_name}-instance-${count.index}"
    engine                  = "aurora-mysql"
    engine_version          = "5.7.12"
    publicly_accessible     = false
    cluster_identifier      = "${aws_rds_cluster.aurora.id}"
    db_subnet_group_name    = "${aws_db_subnet_group.aurora.id}"
    instance_class          = "db.t2.small"
    tags {
        Name = "${var.environment_name}-instance-${count.index}"
        ENV  = "TAG"
    }
    lifecycle {
        ignore_changes = ["cluster_identifier", "id"]
    }
}
