resource "aws_subnet" "subnet" {
  vpc_id                  = var.vpc_id
  cidr_block              = var.cidr_block
  map_public_ip_on_launch = var.assign_public_ip
  availability_zone       = var.availability_zone != "" ? var.availability_zone : null
  tags = {
    Name = var.tag_name
  }
}

resource "aws_route_table_association" "a" {
  subnet_id      = aws_subnet.subnet.id
  route_table_id = var.route_table_id
}