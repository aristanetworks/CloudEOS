output "publicip" {
  value = azurerm_public_ip.publicip.*.ip_address
}
output "allIntfids" {
  description = "The Id of the primary interface of the VM"
  value       = azurerm_network_interface.allIntfs.*.id
}
output "allIntfPrivateIps" {
  value = azurerm_network_interface.allIntfs.*.private_ip_address
}

output "backend_pool_id" {
  value = length(azurerm_lb_backend_address_pool.pool.*.id) > 0 ? azurerm_lb_backend_address_pool.pool[0].id : ""
}

output "ilb_ip" {
  value = length(azurerm_lb.leafha_ilb.*.id) > 0 ? azurerm_lb.leafha_ilb[0].private_ip_address : ""
}
