variable "cluster_id" {
  type = string
}

variable "task_definition_arn" {
  type = string
}

variable "app_name" {
  type = string
  default = "my-app"
}

variable "app_environment" {
  type = string
  default = "dev"
}

variable "desired_count" {
  type = number
}

variable "target_group_arn" {
  type = string
}

variable "container_port" {
  type = number
}

variable "subnets" {
  type = list(string)
}

variable "security_groups" {
  type = list(string)
}