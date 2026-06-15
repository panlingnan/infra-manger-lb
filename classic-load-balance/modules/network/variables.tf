variable "name_prefix" {
  type        = string
  description = "资源名称前缀"
}

variable "project_name" {
  type        = string
  description = "火山引擎项目名"
}

variable "vpc_cidr" {
  type        = string
  description = "VPC CIDR"
}

variable "availability_zones" {
  type        = list(string)
  description = "可用区列表，用于跨 AZ 子网部署"
}

variable "subnet_cidrs" {
  type        = list(string)
  description = "子网 CIDR 列表，长度需与 availability_zones 一致"
}

variable "web_server_port" {
  type        = number
  description = "Web 服务器端口，用于安全组放行"
}

variable "app_server_port" {
  type        = number
  description = "App 服务器端口，用于安全组放行"
}

variable "tags_list" {
  type = list(object({
    key   = string
    value = string
  }))
  description = "通用标签列表"
  default     = []
}
