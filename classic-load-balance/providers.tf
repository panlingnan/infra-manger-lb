# Provider 配置仅在根模块声明，子模块通过 required_providers 继承
# 凭证通过环境变量 VOLCENGINE_ACCESS_KEY / VOLCENGINE_SECRET_KEY 注入，避免硬编码
provider "volcenginecc" {
  endpoints = {
    cloudcontrolapi = "open.stable.volcengineapi-test.com"
  }

  region     = "cn-guilin-boe"
}
