output "private_sub_name" {
  value = aws_subnet.private_subnet.tags.Name
}

output "private_sub" {
  value = aws_subnet.private_subnet.id
}

output "public_sub" {
  value = aws_subnet.public_subnet.id
}