# VPC
output "vpc_id" {
  description = "The ID of the VPC"
  value       = aws_vpc.starrise_dev_clustervpc_v1.id
}

# Subnets
output "private_subnets" {
  description = "List of IDs of private subnets"
  value       = aws_subnet.private.*.id
}

output "public_subnets" {
  description = "List of IDs of public subnets"
  value       = aws_subnet.public.*.id
}

output "nat_gateway_ids" {
  description = "List of IDs of public subnets"
  value       = aws_nat_gateway.natgw.*.id
}