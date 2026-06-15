output "web_instance_ids" {
  description = "Web 层 ECS 实例 ID 列表"
  value       = volcenginecc_ecs_instance.web[*].id
}

output "app_instance_ids" {
  description = "App 层 ECS 实例 ID 列表"
  value       = volcenginecc_ecs_instance.app[*].id
}

output "web_instance_private_ips" {
  description = "Web 层 ECS 主网卡私有 IP 列表"
  value       = [for ins in volcenginecc_ecs_instance.web : ins.primary_network_interface.primary_ip_address]
}

output "app_instance_private_ips" {
  description = "App 层 ECS 主网卡私有 IP 列表"
  value       = [for ins in volcenginecc_ecs_instance.app : ins.primary_network_interface.primary_ip_address]
}
