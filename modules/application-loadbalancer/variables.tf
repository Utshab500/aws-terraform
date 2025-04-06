variable "app_name" {
  type = string
}

variable "security_group_ids" {
  type = list(string)
}

variable "subnet_ids" {
  type = list(string)
}

variable "app_environment" {
  type = string
  default = "dev"
}