###############################
# 全局配置
###############################
variable "region" {
  type        = string
  description = "火山引擎部署区域"
  default     = "cn-guilin-boe"
}

variable "project_name" {
  type        = string
  description = "资源所属的火山引擎项目名"
  default     = "default"
}

variable "name_prefix" {
  type        = string
  description = "全局资源名称前缀，用于在控制台快速识别本工程创建的资源"
  default     = "tf-clb"
}

variable "common_tags" {
  type        = map(string)
  description = "全局通用标签，会被注入到所有支持 Tag 的资源"
  default = {
    Project     = "classic-load-balance"
    Environment = "prod"
    ManagedBy   = "Terraform"
  }
}

###############################
# 网络配置
###############################
variable "vpc_cidr" {
  type        = string
  description = "VPC 的 IPv4 CIDR 段"
  default     = "10.1.0.0/16"
}

variable "availability_zones" {
  type        = list(string)
  description = "可用区列表，建议至少两个以实现跨 AZ 高可用。"
  default     = ["cn-guilin-c", "cn-guilin-local-e"]
}

variable "subnet_cidrs" {
  type        = list(string)
  description = "子网 CIDR 列表，必须与 availability_zones 长度对应"
  default     = ["10.1.2.0/24", "10.1.3.0/24"]
}

###############################
# 计算配置
###############################
variable "enable_compute" {
  type        = bool
  description = "是否创建 Web/App ECS 实例。若账号欠费或所选实例规格在目标可用区不可用，可设为 false 跳过"
  default     = true
}

variable "image_id" {
  type        = string
  description = "ECS 实例使用的镜像 ID（如 image-xxx）。volcenginecc Provider 暂不提供镜像数据源，请通过控制台或 API 查询后填入"
  default     = "image-yzjxq7zrrh8lovxdg9dp"
}

variable "instance_type" {
  type        = string
  description = "ECS 实例规格"
  default     = "ecs.g4i.large"
}

variable "system_volume_type" {
  type        = string
  description = "系统盘类型，可选 ESSD_PL0 / ESSD_FlexPL / PTSSD"
  default     = "ESSD_PL0"
}

variable "system_volume_size_gb" {
  type        = number
  description = "系统盘容量（GB）"
  default     = 50
}

variable "ecs_password" {
  type        = string
  description = "ECS 登录密码，建议通过环境变量 TF_VAR_ecs_password 注入"
  sensitive   = true
  default     = "Aasdsd!1234dsad@D"
}

variable "web_instance_count" {
  type        = number
  description = "Web 层 ECS 实例数量"
  default     = 2
}

variable "app_instance_count" {
  type        = number
  description = "App 层 ECS 实例数量"
  default     = 2
}

variable "web_server_port" {
  type        = number
  description = "Web 服务器后端监听端口"
  default     = 80
}

variable "app_server_port" {
  type        = number
  description = "App 服务器后端监听端口"
  default     = 80
}

###############################
# 负载均衡配置
###############################
variable "enable_load_balancer" {
  type        = bool
  description = "是否创建 NLB。若账号欠费或未授权服务关联角色，可设为 false 跳过"
  default     = true
}

variable "internet_listener_port" {
  type        = number
  description = "公网 NLB 对外监听端口"
  default     = 80
}

variable "intranet_listener_port" {
  type        = number
  description = "私网 NLB 监听端口（Web 层访问 App 层）"
  default     = 8080
}

variable "nlb_cross_zone_enabled" {
  type        = bool
  description = "是否开启跨可用区流量转发"
  default     = true
}

###############################
# RDS 配置
###############################
variable "enable_rds" {
  type        = bool
  description = "是否创建 RDS 实例。若当前账号无 RDS 权限或已欠费，可设为 false 跳过"
  default     = true
}

variable "rds_db_engine_version" {
  type        = string
  description = "RDS MySQL 引擎版本"
  default     = "MySQL_5_7"
}

variable "rds_node_spec" {
  type        = string
  description = "RDS 节点规格"
  default     = "rds.mysql.1c2g"
}

variable "rds_storage_type" {
  type        = string
  description = "RDS 存储类型，可选 LocalSSD / CloudESSD_FlexPL / CloudESSD_PL0"
  default     = "LocalSSD"
}

variable "rds_storage_space_gb" {
  type        = number
  description = "RDS 存储空间（GB）"
  default     = 100
}

variable "rds_super_account_name" {
  type        = string
  description = "RDS 高权限账号名"
  default     = "tf_super"
}

variable "rds_super_account_password" {
  type        = string
  description = "RDS 高权限账号密码，建议通过环境变量 TF_VAR_rds_super_account_password 注入"
  sensitive   = true
  default     = "Aasdsd!1234dsad@D"
}

variable "rds_database_name" {
  type        = string
  description = "RDS 业务数据库名"
  default     = "tf_db"
}

variable "rds_character_set" {
  type        = string
  description = "RDS 数据库默认字符集"
  default     = "utf8mb4"
}

###############################
# 对象存储配置
###############################
variable "enable_tos" {
  type        = bool
  description = "是否创建 TOS 桶。若当前账号 TOS 服务被禁用或已欠费，可设为 false 跳过"
  default     = true
}

variable "tos_bucket_name" {
  type        = string
  description = "TOS 桶名（全局唯一），不填则自动生成"
  default     = "tf-tos-bucket"
}

variable "tos_enable_version_status" {
  type        = string
  description = "TOS 版本控制状态，可选 Enabled / Suspended"
  default     = "Enabled"
}
