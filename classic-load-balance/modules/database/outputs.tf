output "rds_instance_id" {
  description = "RDS 实例 ID"
  value       = volcenginecc_rdsmysql_instance.main.instance_id
}

output "rds_engine_version" {
  description = "RDS 引擎版本"
  value       = volcenginecc_rdsmysql_instance.main.db_engine_version
}

output "database_name" {
  description = "RDS 业务数据库名"
  value       = volcenginecc_rdsmysql_database.main.name
}

output "super_account_name" {
  description = "RDS 高权限账号名"
  value       = volcenginecc_rdsmysql_instance.main.super_account_name
}
