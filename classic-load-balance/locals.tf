locals {
  # 将 map 形式的通用标签转换为 volcenginecc 资源所需的 list(object) 形式
  tags_list = [for k, v in var.common_tags : { key = k, value = v }]

  # TOS 桶名：用户显式指定时优先使用；否则基于工程名 + 部署日期生成
  # 注意：使用 plantimestamp() 而非 timestamp() 以避免每次 plan 都触发桶名变更导致重建
  tos_bucket_name = var.tos_bucket_name != "" ? var.tos_bucket_name : format("%s-tos-%s", var.name_prefix, formatdate("YYYYMMDD", plantimestamp()))
}
