###############################################################################
# storage 模块
# 封装资源：
#   - TOS 对象存储桶（用于存放图片、视频、日志等非结构化数据）
# 设计：默认开启版本控制，便于历史版本追溯与误删恢复
###############################################################################

resource "volcenginecc_tos_bucket" "main" {
  name                  = var.bucket_name
  enable_version_status = var.enable_version_status
  storage_class         = "STANDARD"
  bucket_type           = "fns"
  project_name          = var.project_name

  tags = var.tags_list
}
