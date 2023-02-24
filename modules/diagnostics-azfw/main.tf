resource "azurerm_monitor_diagnostic_setting" "this" {
  name                                           = var.name
  target_resource_id                             = var.target_resource_id
  log_analytics_workspace_id                     = var.log_analytics_workspace_id       
  dynamic "log" {
    for_each = var.logs == null ? [] : var.logs
    content {
      #name = log.value.name
      category = log.value.category
      enabled = log.value.enabled
      retention_policy {
          enabled = log.value.retention_policy_enabled
          days = log.value.retention_days
      }
    }
  }
  dynamic "metric" {
    for_each = var.metrics == null ? [] : var.metrics
    content {
      #name = metric.value.name
      category = metric.value.category
      enabled = metric.value.enabled
      retention_policy {
          enabled = metric.value.retention_policy_enabled
          days = metric.value.retention_days
      }
    }
  }


#TF Bug, comment out lifecycle if log_analytics_workspace_id needs to be changed

#   lifecycle {
#     ignore_changes = [ log_analytics_workspace_id ]
#   }

}
