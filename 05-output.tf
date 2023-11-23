output "instance_public_ips" {
  value = aws_instance.public_instance.*.public_ip
}

output "instance_public_dns" {
  value = aws_instance.public_instance.*.public_dns
}
