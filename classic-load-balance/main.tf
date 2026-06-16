###############################################################################
# 根模块：高可用三层 Web 应用部署
# - 接入层：公网/私网 NLB 实现跨可用区负载均衡
# - 应用层：Web / App 两组 ECS，跨可用区部署
# - 数据层：RDS MySQL 主备 + TOS 对象存储
###############################################################################

# 前置校验：availability_zones 必须以 region 为前缀，避免 InvalidZoneId.NotFound
check "region_zone_match" {
  assert {
    condition     = alltrue([for z in var.availability_zones : startswith(z, var.region)])
    error_message = "availability_zones 中的可用区必须以 region (${var.region}) 为前缀，例如 ${var.region}-a。当前值: ${join(",", var.availability_zones)}"
  }
}

# 前置校验：subnet_cidrs 与 availability_zones 长度必须一致
check "subnet_zone_alignment" {
  assert {
    condition     = length(var.subnet_cidrs) == length(var.availability_zones)
    error_message = "subnet_cidrs (${length(var.subnet_cidrs)}) 与 availability_zones (${length(var.availability_zones)}) 数量不一致"
  }
}

module "network" {
  source = "./modules/network"

  name_prefix        = var.name_prefix
  project_name       = var.project_name
  vpc_cidr           = var.vpc_cidr
  availability_zones = var.availability_zones
  subnet_cidrs       = var.subnet_cidrs
  web_server_port    = var.web_server_port
  app_server_port    = var.app_server_port
  tags_list          = local.tags_list
}

module "compute" {
  source = "./modules/compute"
  count  = var.enable_compute ? 1 : 0

  name_prefix        = var.name_prefix
  project_name       = var.project_name
  vpc_id             = module.network.vpc_id
  subnet_ids         = module.network.subnet_ids
  subnet_zone_ids    = module.network.subnet_zone_ids
  security_group_id  = module.network.security_group_id
  image_id           = var.image_id
  instance_type      = var.instance_type
  system_volume_type = var.system_volume_type
  system_volume_size = var.system_volume_size_gb
  ecs_password       = var.ecs_password
  web_instance_count = var.web_instance_count
  app_instance_count = var.app_instance_count
  tags_list          = local.tags_list
}

module "load_balancer" {
  source = "./modules/load_balancer"
  count  = var.enable_load_balancer && var.enable_compute ? 1 : 0

  name_prefix            = var.name_prefix
  project_name           = var.project_name
  vpc_id                 = module.network.vpc_id
  security_group_id      = module.network.security_group_id
  subnet_ids             = module.network.subnet_ids
  subnet_zone_ids        = module.network.subnet_zone_ids
  cross_zone_enabled     = var.nlb_cross_zone_enabled
  web_instance_ids       = module.compute[0].web_instance_ids
  web_instance_ips       = module.compute[0].web_instance_private_ips
  app_instance_ids       = module.compute[0].app_instance_ids
  app_instance_ips       = module.compute[0].app_instance_private_ips
  web_server_port        = var.web_server_port
  app_server_port        = var.app_server_port
  internet_listener_port = var.internet_listener_port
  intranet_listener_port = var.intranet_listener_port
  tags_list              = local.tags_list
}

module "database" {
  source = "./modules/database"
  count  = var.enable_rds ? 1 : 0

  name_prefix            = var.name_prefix
  project_name           = var.project_name
  vpc_id                 = module.network.vpc_id
  subnet_id              = module.network.subnet_ids[0]
  availability_zones     = module.network.subnet_zone_ids
  db_engine_version      = var.rds_db_engine_version
  node_spec              = var.rds_node_spec
  storage_type           = var.rds_storage_type
  storage_space_gb       = var.rds_storage_space_gb
  super_account_name     = var.rds_super_account_name
  super_account_password = var.rds_super_account_password
  database_name          = var.rds_database_name
  character_set          = var.rds_character_set
  tags_list              = local.tags_list
}

module "storage" {
  source = "./modules/storage"
  count  = var.enable_tos ? 1 : 0

  bucket_name           = local.tos_bucket_name
  project_name          = var.project_name
  enable_version_status = var.tos_enable_version_status
  tags_list             = local.tags_list
}
