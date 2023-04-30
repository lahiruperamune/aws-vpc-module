output "vpc_id" {
  description = "The ID of the VPC"
  value       = try(aws_vpc.main.id, null)
}

output "vpc_arn" {
  description = "The ARN of the VPC"
  value       = try(aws_vpc.main.arn, null)
}

output "vpc_cidr_block" {
  description = "The CIDR block of the VPC"
  value       = try(aws_vpc.main.cidr_block, null)
}