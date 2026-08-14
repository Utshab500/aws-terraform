variable "load_balancer_arn" {
  type = string
}

variable "listener_port" {
  type = number
}

variable "protocol" {
  type = string
}

variable "target_group_arn" {
    type = string
}