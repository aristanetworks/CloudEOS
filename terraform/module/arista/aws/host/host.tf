provider "aws" {
  region = var.region
}

resource "aws_network_interface" "intf" {
         subnet_id   = var.subnet_id
         private_ips = var.private_ips
         tags = {
             Name = "primary_network_interface"
         }
}

resource "aws_instance" "host" {
         ami = var.ami
         instance_type = var.instance_type
         tags = var.tags
         key_name = var.keypair_name

         network_interface {
            network_interface_id = aws_network_interface.intf.id
            device_index = 0
         }
}
