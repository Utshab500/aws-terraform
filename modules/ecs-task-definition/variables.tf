variable "app_name" {
  type = string
}

variable "app_environment" {
  type = string
  default = "dev"
}

variable "app_container_image" {
  type = string
}

variable "app_port" {
  type = number
}