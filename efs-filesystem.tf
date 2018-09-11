resource "aws_efs_file_system" "efs" {
    creation_token = "${var.environment_name}"

    tags {
    Name    = "${var.environment_name}"
    ENV     = "PROD"
    }
}

resource "aws_efs_mount_target" "main" {
    count           = "${length(split(",", data.terraform_remote_state.vpc.azs))}"
    file_system_id  = "${aws_efs_file_system.efs.id}"
    subnet_id       = "${element(split(",", data.terraform_remote_state.vpc.private_subnets), count.index)}"
    security_groups = ["${aws_security_group.efs_securitygroup.id}"]
}