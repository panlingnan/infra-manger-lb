output "vpc_id" {
  description = "VPC ID"
  value       = volcenginecc_vpc_vpc.main.id
}

output "vpc_cidr" {
  description = "VPC CIDR 段"
  value       = volcenginecc_vpc_vpc.main.cidr_block
}

output "subnet_ids" {
  description = "子网 ID 列表"
  value       = volcenginecc_vpc_subnet.this[*].id
}

output "subnet_zone_ids" {
  description = "子网对应的可用区 ID 列表"
  value       = volcenginecc_vpc_subnet.this[*].zone_id
}

output "security_group_id" {
  description = "安全组 ID"
  value       = volcenginecc_vpc_security_group.main.id
}
