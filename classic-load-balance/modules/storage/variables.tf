variable "bucket_name" {
  type        = string
  description = "TOS 桶名（全局唯一）"
}

variable "project_name" {
  type        = string
  description = "火山引擎项目名"
}

variable "enable_version_status" {
  type        = string
  description = "TOS 版本控制状态，可选 Enabled / Suspended"
  default     = "Enabled"
}

variable "tags_list" {
  type = list(object({
    key   = string
    value = string
  }))
  description = "通用标签"
  default     = []
}
