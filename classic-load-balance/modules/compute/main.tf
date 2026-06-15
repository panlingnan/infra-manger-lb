###############################################################################
# compute 模块
# 封装资源：
#   - Web 层 ECS 实例（接收来自公网 NLB 的 HTTP 请求）
#   - App 层 ECS 实例（处理核心业务逻辑，与 RDS 交互）
# 设计：通过 count.index 对子网取模实现实例跨 AZ 均匀分布
###############################################################################

locals {
  subnets_length = length(var.subnet_ids)
}

# Web 层 ECS：处理前端请求
resource "volcenginecc_ecs_instance" "web" {
  count         = var.web_instance_count
  instance_name = format("%s-web-%02d", var.name_prefix, count.index + 1)
  instance_type = var.instance_type
  zone_id       = var.subnet_zone_ids[count.index % local.subnets_length]
  password      = var.ecs_password
  project_name  = var.project_name

  image = {
    image_id = var.image_id
  }

  primary_network_interface = {
    subnet_id          = var.subnet_ids[count.index % local.subnets_length]
    security_group_ids = [var.security_group_id]
  }

  system_volume = {
    size                 = var.system_volume_size
    volume_type          = var.system_volume_type
    delete_with_instance = true
  }

  tags = concat(var.tags_list, [
    { key = "Tier", value = "web" }
  ])

  # 实例规格变更需停机操作，由运维显式触发；password 仅在创建时下发
  # image / primary_network_interface / system_volume 中部分 read-only 字段
  # 在创建后由 Provider 回写，会持续触发 in-place drift，故一并忽略
  lifecycle {
    ignore_changes = [
      instance_type,
      password,
      image,
      primary_network_interface,
      system_volume,
    ]
  }
}

# App 层 ECS：处理业务逻辑，与 RDS / TOS 交互
resource "volcenginecc_ecs_instance" "app" {
  count         = var.app_instance_count
  instance_name = format("%s-app-%02d", var.name_prefix, count.index + 1)
  instance_type = var.instance_type
  zone_id       = var.subnet_zone_ids[count.index % local.subnets_length]
  password      = var.ecs_password
  project_name  = var.project_name

  image = {
    image_id = var.image_id
  }

  primary_network_interface = {
    subnet_id          = var.subnet_ids[count.index % local.subnets_length]
    security_group_ids = [var.security_group_id]
  }

  system_volume = {
    size                 = var.system_volume_size
    volume_type          = var.system_volume_type
    delete_with_instance = true
  }

  tags = concat(var.tags_list, [
    { key = "Tier", value = "app" }
  ])

  lifecycle {
    ignore_changes = [
      instance_type,
      password,
      image,
      primary_network_interface,
      system_volume,
    ]
  }
}
