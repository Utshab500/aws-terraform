variable "vpc_id" {
  type = string
}

variable "tag_name" {
  type = string
}

variable "cidr_block" {
  type = string
  default = "10.0.0.0/16"
}

variable "route_table_id" {
  type = string
}

variable "assign_public_ip" {
  type = bool
  default = false
}