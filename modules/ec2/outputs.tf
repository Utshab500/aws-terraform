output "instance_id" {
  value = var.use_spot_instance ? aws_spot_instance_request.ec2_spot_instance[0].spot_instance_id : aws_instance.ec2_instance[0].id
}

output "instance_public_ip" {
  value = var.use_spot_instance ? aws_spot_instance_request.ec2_spot_instance[0].public_ip : aws_instance.ec2_instance[0].public_ip
}
