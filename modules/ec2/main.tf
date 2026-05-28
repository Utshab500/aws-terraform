resource "aws_instance" "ec2_instance" {
  count                  = var.use_spot_instance ? 0 : 1
  ami                    = var.ami # Specify the desired AMI ID for your region
  instance_type          = var.instance_type
  key_name               = var.key_name
  iam_instance_profile   = var.iam_instance_profile
  subnet_id              = var.subnet_id
  vpc_security_group_ids = var.vpc_security_group_ids
  user_data              = var.user_data

  root_block_device {
    volume_size = var.volume_size
  }

  tags = {
    Name = var.tag_name
  }
}

resource "aws_spot_instance_request" "ec2_spot_instance" {
  count                  = var.use_spot_instance ? 1 : 0
  ami                    = var.ami
  instance_type          = var.instance_type
  key_name               = var.key_name
  iam_instance_profile   = var.iam_instance_profile
  subnet_id              = var.subnet_id
  vpc_security_group_ids = var.vpc_security_group_ids
  user_data              = var.user_data

  spot_price           = var.spot_max_price
  wait_for_fulfillment = true

  root_block_device {
    volume_size = var.volume_size
  }

  tags = {
    Name = var.tag_name
  }
}
