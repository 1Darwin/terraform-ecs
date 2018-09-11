output "EFS_DNSNAME" {
    value = "${aws_efs_file_system.efs.dns_name}"
}
output "EFS_ID" {
    value = "${aws_efs_file_system.efs.id}"
}
