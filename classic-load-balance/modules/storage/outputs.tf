output "bucket_name" {
  description = "TOS 桶名"
  value       = volcenginecc_tos_bucket.main.name
}

output "bucket_id" {
  description = "TOS 桶资源 ID"
  value       = volcenginecc_tos_bucket.main.id
}

output "intranet_endpoint" {
  description = "TOS 桶私网访问端点"
  value       = volcenginecc_tos_bucket.main.intranet_endpoint
}

output "extranet_endpoint" {
  description = "TOS 桶公网访问端点"
  value       = volcenginecc_tos_bucket.main.extranet_endpoint
}
