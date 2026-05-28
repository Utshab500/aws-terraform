variable "ami" {
  type    = string
  default = "ami-04b70fa74e45c3917"
}

variable "instance_type" {
  type    = string
  default = "t2.micro"
}

variable "key_name" {
  type    = string
  default = null
}

variable "iam_instance_profile" {
  type    = string
  default = null
}

variable "vpc_security_group_ids" {
  type = list(string)
}

variable "subnet_id" {
  type = string
}

variable "user_data" {
  type    = string
  default = ""
}

variable "tag_name" {
  type = string
}

variable "volume_size" {
  type    = number
  default = 8
}

variable "use_spot_instance" {
  type    = bool
  default = false
}

variable "spot_max_price" {
  type    = string
  default = null
}