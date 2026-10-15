output "ba_vpc_id" {
  description = "BA subnet private"
  value       = aws_vpc.ba_vpc.id
}

output "ba_subnet_private_id" {
  description = "ba subnet private"
  value       = aws_subnet.ba_subnet_private.id
}

output "ba_subnet_public_id" {
  description = "ba subnet public"
  value       = aws_subnet.ba_subnet_public.id
}

