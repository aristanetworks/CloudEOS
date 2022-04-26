// Copyright (c) 2020 Arista Networks, Inc.
// Use of this source code is governed by the Apache License 2.0
// that can be found in the LICENSE file.
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

data "cloudinit_config" "cloudinit" {
  gzip          = false
  base64_encode = false

  part {
    content_type = "text/x-shellscript"
    content      = file("${path.module}/user_data.sh")
  }

  part {
    content_type = "text/cloud-config"
    content      = templatefile("${path.module}/user_data.tpl", {
      username = var.username,
      passwd   = var.passwd
    })
  }
}

resource "aws_instance" "host" {
  ami           = var.ami
  instance_type = var.instance_type
  tags          = var.tags
  key_name      = var.keypair_name
  user_data     = data.cloudinit_config.cloudinit.rendered
  network_interface {
    network_interface_id = aws_network_interface.intf.id
    device_index         = 0
  }
}
