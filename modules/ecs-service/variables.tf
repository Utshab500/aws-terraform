variable "cluster_id" {
  type = string
}

variable "task_definition_arn" {
  type = string
}

variable "service_name" {
  type = string
  default = "my-service"
}

variable "desired_count" {
  type = number
}

variable "subnet" {
  type = list(string)
}

variable "security_group" {
  type = list(string)
}