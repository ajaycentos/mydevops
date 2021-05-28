output "aws_instance1_public_IP_output" {
  value = aws_instance.http_server.*.public_ip
}


