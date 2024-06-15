resource "aws_route_table" "route_table" {
  vpc_id = var.vpc_id

  # Public route
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = var.igw_id
  }

  tags = {
    Name = var.tag_name
  }
}