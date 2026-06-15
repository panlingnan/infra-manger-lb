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
  description = "实例所属 VPC ID"
}

variable "subnet_ids" {
  type        = list(string)
  description = "可选子网 ID 列表，按 count.index 取模轮询分配，实现跨 AZ 部署"
}

variable "subnet_zone_ids" {
  type        = list(string)
  description = "子网对应的可用区 ID 列表"
}

variable "security_group_id" {
  type        = string
  description = "实例绑定的安全组 ID"
}

variable "image_id" {
  type        = string
  description = "ECS 实例镜像 ID"
}

variable "instance_type" {
  type        = string
  description = "ECS 实例规格"
}

variable "system_volume_type" {
  type        = string
  description = "系统盘类型"
}

variable "system_volume_size" {
  type        = number
  description = "系统盘容量（GB）"
}

variable "ecs_password" {
  type        = string
  description = "ECS 登录密码"
  sensitive   = true
}

variable "web_instance_count" {
  type        = number
  description = "Web 实例数量"
}

variable "app_instance_count" {
  type        = number
  description = "App 实例数量"
}

variable "tags_list" {
  type = list(object({
    key   = string
    value = string
  }))
  description = "通用标签"
  default     = []
}
