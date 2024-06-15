variable "vpc_id" {
  type = string
}

variable "tag_name" {
  type = string
}

variable "name" {
  type = string
  default = "example_sg"
}

variable "description" {
  type = string
  default = "Example security group"
}