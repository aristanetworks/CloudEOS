output "intf_private_ips" {
  value = aws_network_interface.intf.*.private_ips
}