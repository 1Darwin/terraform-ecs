variable "environment_name" {
  default = ""
}
variable "ecs_key_pair_name" {
  default = ""
}

### DOCKER IMAGE

variable "docker_image" {
  default = ""
}
variable "image_tag" {
  default = ""
}

## ASG Settings
variable "asg_node_des" {
  default = ""
}
variable "asg_node_min" {
  default = ""
}
variable "asg_node_max" {
  default = ""
}

### AURORA CLUSTER
variable "rds_master_username" {
  default = ""
}
variable "rds_master_password" {
  default = ""
}
variable "rds_db_default_name" {
  default = ""
}

#### WORDPRESS
variable "wp_db_name" {
  default = ""
}
variable "wp_current_domain" {
  default = ""
}
variable "wp_db_user" {
  default = ""
}
variable "wp_db_password" {
  default = ""
}

#### MOUNT POINTS
variable "source_volume_1" {
  default = ""
}
variable "container_path_1" {
  default = ""
}
#### SENDGRID API
variable "sendgrid_api_token" {
  default = ""
}

## S3 Plugin
variable "as3cf_access_key" {
  default = ""
}
variable "as3cf_secret_key" {
  default = ""
}