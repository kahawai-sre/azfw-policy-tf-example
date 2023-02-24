
output "privatezonevnetlink_id" {
  #value       = azapi_update_resource.this[each.key].id

  value = [
    for this in azapi_update_resource.this : this.id
  ]
}


