variable "name_prefix" {
  type        = string
  description = "资源名称前缀"
}

variable "project_name" {
  type        = string
  description = "火山引擎项目名"
}

variable "vpc_id" {
  type        = string
  description = "NLB 所属 VPC ID"
}

variable "security_group_id" {
  type        = string
  description = "NLB 关联的安全组 ID"
}

variable "subnet_ids" {
  type        = list(string)
  description = "NLB 监听的子网 ID 列表（多 AZ）"
}

variable "subnet_zone_ids" {
  type        = list(string)
  description = "子网对应的可用区 ID 列表"
}

variable "cross_zone_enabled" {
  type        = bool
  description = "是否开启跨可用区流量转发"
  default     = true
}

variable "web_instance_ids" {
  type        = list(string)
  description = "Web 层 ECS 实例 ID 列表"
}

variable "web_instance_ips" {
  type        = list(string)
  description = "Web 层 ECS 实例私有 IP 列表"
}

variable "app_instance_ids" {
  type        = list(string)
  description = "App 层 ECS 实例 ID 列表"
}

variable "app_instance_ips" {
  type        = list(string)
  description = "App 层 ECS 实例私有 IP 列表"
}

variable "web_server_port" {
  type        = number
  description = "Web 层后端端口"
}

variable "app_server_port" {
  type        = number
  description = "App 层后端端口"
}

variable "internet_listener_port" {
  type        = number
  description = "公网 NLB 监听端口"
}

variable "intranet_listener_port" {
  type        = number
  description = "私网 NLB 监听端口"
}

variable "tags_list" {
  type = list(object({
    key   = string
    value = string
  }))
  description = "通用标签"
  default     = []
}
