# output "key_pair" {
#   value = aws_key_pair.key_pair
# }
output "public_key_name" {
  value = aws_key_pair.key_pair.key_name
}
output "public_key_path" {
  value = aws_key_pair.key_pair.public_key
}