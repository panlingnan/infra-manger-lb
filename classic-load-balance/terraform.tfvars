###############################
# 环境与全局
###############################
region       = "cn-beijing"
project_name = "default"
name_prefix  = "tf-clb"

###############################
# 网络
###############################
vpc_cidr           = "10.1.0.0/16"
availability_zones = ["cn-beijing-a", "cn-beijing-b"]
subnet_cidrs       = ["10.1.2.0/24", "10.1.3.0/24"]

###############################
# 计算
# 注意：image_id 需提前在火山引擎控制台或 API 中查询所选 instance_type
# 在指定可用区下可用的公共镜像 ID 后填入
###############################
enable_compute     = true
image_id           = "image-ydf193g9cqb6uoeqqqj8" # Ubuntu 24.04 64 bit (cn-beijing 公共镜像)
instance_type      = "ecs.g3i.large"              # cn-beijing-a/b 通用，2C8G
system_volume_type = "ESSD_PL0"
web_instance_count = 2
app_instance_count = 2

# 推荐通过环境变量 TF_VAR_ecs_password 注入，避免明文落库
# ecs_password = "Root@12345Aa"

###############################
# 负载均衡
###############################
enable_load_balancer   = true
internet_listener_port = 80
intranet_listener_port = 8080
nlb_cross_zone_enabled = true

###############################
# RDS
# 注意：账号需具备 rds:CreateDBInstance 等权限
###############################
enable_rds             = true
rds_db_engine_version  = "MySQL_5_7"
rds_node_spec          = "rds.mysql.1c2g"
rds_storage_type       = "LocalSSD"
rds_storage_space_gb   = 100
rds_super_account_name = "tf_super"
# 推荐通过环境变量 TF_VAR_rds_super_account_password 注入
# rds_super_account_password = "Db@12345Aa"
rds_database_name = "tf_db"
rds_character_set = "utf8mb4"

###############################
# 对象存储
# 注意：账号需开通 TOS 服务且未欠费
# tos_bucket_name 全局唯一；如不指定将基于 name_prefix + 当前日期自动生成
###############################
enable_tos                = true
tos_bucket_name           = "tf-clb-tos-202606030848"
tos_enable_version_status = "Enabled"
