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
