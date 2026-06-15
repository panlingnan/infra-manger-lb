output "internet_nlb_id" {
  description = "公网 NLB 实例 ID"
  value       = volcenginecc_clb_nlb.internet.load_balancer_id
}

output "internet_nlb_dns_name" {
  description = "公网 NLB DNS 域名"
  value       = volcenginecc_clb_nlb.internet.dns_name
}

output "intranet_nlb_id" {
  description = "私网 NLB 实例 ID"
  value       = volcenginecc_clb_nlb.intranet.load_balancer_id
}

output "intranet_nlb_dns_name" {
  description = "私网 NLB DNS 域名"
  value       = volcenginecc_clb_nlb.intranet.dns_name
}

output "web_server_group_id" {
  description = "Web 层服务器组 ID"
  value       = volcenginecc_clb_nlb_server_group.web.server_group_id
}

output "app_server_group_id" {
  description = "App 层服务器组 ID"
  value       = volcenginecc_clb_nlb_server_group.app.server_group_id
}
