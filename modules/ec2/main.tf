resource "aws_instance" "ec2_instance" {
  ami           = var.ami  # Specify the desired AMI ID for your region
  instance_type = var.instance_type
  key_name      = var.key_name
  subnet_id = var.subnet_id
  vpc_security_group_ids = var.vpc_security_group_ids
  user_data = var.user_data
  root_block_device {
    volume_size = var.volume_size
  }
  tags = {
    Name = var.tag_name
  }
}
