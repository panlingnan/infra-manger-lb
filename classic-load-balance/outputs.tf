###############################
# 网络输出
###############################
output "vpc_id" {
  description = "VPC ID"
  value       = module.network.vpc_id
}

output "subnet_ids" {
  description = "全部子网 ID"
  value       = module.network.subnet_ids
}

output "security_group_id" {
  description = "安全组 ID"
  value       = module.network.security_group_id
}

###############################
# 计算输出
###############################
output "web_instance_ids" {
  description = "Web 层 ECS 实例 ID 列表（未启用时为空）"
  value       = length(module.compute) > 0 ? module.compute[0].web_instance_ids : []
}

output "app_instance_ids" {
  description = "App 层 ECS 实例 ID 列表（未启用时为空）"
  value       = length(module.compute) > 0 ? module.compute[0].app_instance_ids : []
}

###############################
# 负载均衡输出
###############################
output "internet_nlb_id" {
  description = "公网 NLB 实例 ID（未启用时为空）"
  value       = length(module.load_balancer) > 0 ? module.load_balancer[0].internet_nlb_id : null
}

output "intranet_nlb_id" {
  description = "私网 NLB 实例 ID（未启用时为空）"
  value       = length(module.load_balancer) > 0 ? module.load_balancer[0].intranet_nlb_id : null
}

###############################
# 数据库输出
###############################
output "rds_instance_id" {
  description = "RDS 实例 ID（未启用时为空）"
  value       = length(module.database) > 0 ? module.database[0].rds_instance_id : null
}

output "rds_database_name" {
  description = "RDS 业务数据库名（未启用时为空）"
  value       = length(module.database) > 0 ? module.database[0].database_name : null
}

###############################
# 对象存储输出
###############################
output "tos_bucket_name" {
  description = "TOS 桶名（未启用时为空）"
  value       = length(module.storage) > 0 ? module.storage[0].bucket_name : null
}
