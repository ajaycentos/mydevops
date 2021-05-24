output "aws_instance1_public_dns_output" {
  value = aws_instance.http_server[0].public_dns
}


