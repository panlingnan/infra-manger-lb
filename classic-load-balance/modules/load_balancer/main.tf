###############################################################################
# load_balancer 模块
# 封装资源：
#   - 公网 NLB 实例 + 服务器组 + 监听器（接入层，分发互联网流量到 Web 层）
#   - 私网 NLB 实例 + 服务器组 + 监听器（Web 层访问 App 层的内部分发）
# 设计：监听器使用 TCP 协议、HTTP 健康检查；后端服务器组绑定 ECS 私网 IP
###############################################################################

locals {
  zone_mappings = [
    for i in range(length(var.subnet_ids)) : {
      subnet_id = var.subnet_ids[i]
      zone_id   = var.subnet_zone_ids[i]
    }
  ]
}

###############################
# 公网 NLB（接入层 - 互联网入口）
###############################
resource "volcenginecc_clb_nlb" "internet" {
  load_balancer_name = "${var.name_prefix}-nlb-internet"
  ipv_4_network_type = "internet"
  ip_address_version = "ipv4"
  vpc_id             = var.vpc_id
  security_group_ids = [var.security_group_id]
  cross_zone_enabled = var.cross_zone_enabled
  zone_mappings      = local.zone_mappings
  project_name       = var.project_name

  modification_protection_status = "ConsoleProtection"

  tags = var.tags_list
}

resource "volcenginecc_clb_nlb_server_group" "web" {
  vpc_id            = var.vpc_id
  server_group_name = "${var.name_prefix}-web-sg"
  type              = "instance"
  protocol          = "TCP"
  project_name      = var.project_name

  bypass_security_group_enabled = false
  session_persistence_enabled   = true
  session_persistence_timeout   = 100

  health_check = {
    enabled = true
    type    = "HTTP"
    port    = var.web_server_port
    uri     = "/"
  }

  servers = [
    for idx, id in var.web_instance_ids : {
      instance_id = id
      type        = "ecs"
      ip          = var.web_instance_ips[idx]
      port        = var.web_server_port
      weight      = 100
    }
  ]

  tags = var.tags_list
}

resource "volcenginecc_clb_nlb_listener" "internet" {
  load_balancer_id   = volcenginecc_clb_nlb.internet.load_balancer_id
  server_group_id    = volcenginecc_clb_nlb_server_group.web.server_group_id
  listener_name      = "${var.name_prefix}-internet-listener"
  protocol           = "TCP"
  port               = var.internet_listener_port
  enabled            = true
  connection_timeout = 60

  tags = var.tags_list
}

###############################
# 私网 NLB（Web -> App 内部分发）
###############################
resource "volcenginecc_clb_nlb" "intranet" {
  load_balancer_name = "${var.name_prefix}-nlb-intranet"
  ipv_4_network_type = "intranet"
  ip_address_version = "ipv4"
  vpc_id             = var.vpc_id
  security_group_ids = [var.security_group_id]
  cross_zone_enabled = var.cross_zone_enabled
  zone_mappings      = local.zone_mappings
  project_name       = var.project_name

  modification_protection_status = "ConsoleProtection"

  tags = var.tags_list
}

resource "volcenginecc_clb_nlb_server_group" "app" {
  vpc_id            = var.vpc_id
  server_group_name = "${var.name_prefix}-app-sg"
  type              = "instance"
  protocol          = "TCP"
  project_name      = var.project_name

  bypass_security_group_enabled = false
  session_persistence_enabled   = true
  session_persistence_timeout   = 100

  health_check = {
    enabled = true
    type    = "HTTP"
    port    = var.app_server_port
    uri     = "/"
  }

  servers = [
    for idx, id in var.app_instance_ids : {
      instance_id = id
      type        = "ecs"
      ip          = var.app_instance_ips[idx]
      port        = var.app_server_port
      weight      = 100
    }
  ]

  tags = var.tags_list
}

resource "volcenginecc_clb_nlb_listener" "intranet" {
  load_balancer_id   = volcenginecc_clb_nlb.intranet.load_balancer_id
  server_group_id    = volcenginecc_clb_nlb_server_group.app.server_group_id
  listener_name      = "${var.name_prefix}-intranet-listener"
  protocol           = "TCP"
  port               = var.intranet_listener_port
  enabled            = true
  connection_timeout = 60

  tags = var.tags_list
}
