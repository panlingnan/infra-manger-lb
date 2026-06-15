###############################################################################
# network 模块
# 封装资源：
#   - VPC（私有网络）
#   - 跨 AZ 子网
#   - 安全组（含基础放行规则）
# 提供能力：为整个三层应用提供网络底座
###############################################################################

# VPC 网络底座，支撑后续所有云资源
resource "volcenginecc_vpc_vpc" "main" {
  vpc_name     = "${var.name_prefix}-vpc"
  cidr_block   = var.vpc_cidr
  project_name = var.project_name
  tags         = var.tags_list
}

# 跨可用区子网：分别承载 ECS、NLB、RDS，子网与 AZ 一一对应以实现跨 AZ 高可用
resource "volcenginecc_vpc_subnet" "this" {
  count       = length(var.subnet_cidrs)
  vpc_id      = volcenginecc_vpc_vpc.main.id
  zone_id     = var.availability_zones[count.index]
  subnet_name = format("%s-subnet-%02d", var.name_prefix, count.index + 1)
  cidr_block  = var.subnet_cidrs[count.index]
  tags        = var.tags_list
}

locals {
  # 入站规则：放行 SSH 与 Web 端口；当 app 端口与 web 不一致时再放行 app 端口（仅 VPC 内）
  ingress_permissions_base = [
    {
      description     = "Allow SSH from internet"
      policy          = "accept"
      port_start      = 22
      port_end        = 22
      protocol        = "tcp"
      priority        = 1
      cidr_ip         = "0.0.0.0/0"
      prefix_list_id  = ""
      source_group_id = ""
    },
    {
      description     = "Allow HTTP web port from internet"
      policy          = "accept"
      port_start      = var.web_server_port
      port_end        = var.web_server_port
      protocol        = "tcp"
      priority        = 2
      cidr_ip         = "0.0.0.0/0"
      prefix_list_id  = ""
      source_group_id = ""
    }
  ]

  ingress_permissions_app = var.app_server_port != var.web_server_port ? [
    {
      description     = "Allow HTTP app port within VPC"
      policy          = "accept"
      port_start      = var.app_server_port
      port_end        = var.app_server_port
      protocol        = "tcp"
      priority        = 3
      cidr_ip         = var.vpc_cidr
      prefix_list_id  = ""
      source_group_id = ""
    }
  ] : []

  ingress_permissions = concat(local.ingress_permissions_base, local.ingress_permissions_app)
}

# 安全组：控制 ECS 入站访问
# 出站默认放行（不显式声明 egress_permissions，沿用系统默认全通规则避免冲突）
resource "volcenginecc_vpc_security_group" "main" {
  vpc_id              = volcenginecc_vpc_vpc.main.id
  security_group_name = "${var.name_prefix}-sg"
  description         = "Security group for classic-load-balance web app"
  project_name        = var.project_name

  ingress_permissions = local.ingress_permissions

  tags = var.tags_list
}
