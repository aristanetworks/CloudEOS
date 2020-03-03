provider "aws" {           
  region = var.region
}

resource "aws_security_group" "allow_iperf3" {
  name        = "allow_iperf3"
  description = "Allow iperf3 traffic"
  vpc_id = var.vpc_id
  ingress {
    from_port   = 4500
    to_port     = 4500
    protocol    = "udp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  ingress {
    from_port   = 500
    to_port     = 500
    protocol    = "udp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  // ssh port
  ingress {
    protocol    = "tcp"
    from_port   = 22
    to_port     = 22
    cidr_blocks = ["0.0.0.0/0"]
  }
  // icmp (ping)
  ingress {
    protocol    = "icmp"
    from_port   = "-1"
    to_port     = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
  // iperf3
  ingress {
    from_port   = 5005
    to_port     = 5005
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  // iperf3 default port
  ingress {
    from_port   = 5201
    to_port     = 5201
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  // iperf3
  ingress {
    from_port   = 5005
    to_port     = 5005
    protocol    = "udp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  // iperf3 default port
  ingress {
    from_port   = 5201
    to_port     = 5201
    protocol    = "udp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  egress {
    from_port       = 0
    to_port         = 0
    protocol        = "-1"
    cidr_blocks     = ["0.0.0.0/0"]
  }
}

resource "aws_network_interface" "intf" {
         subnet_id   = var.subnet_id
         private_ips = var.private_ips
         security_groups = [ aws_security_group.allow_iperf3.id ]
         tags = {
             Name = "primary_network_interface"
         }
}

data "template_file" "init-script" {
     template = file("${path.module}/user_data.tpl")

     vars = {
        username = var.username
        passwd = var.passwd
     }
}

data "template_cloudinit_config" "cloudinit"  {
     gzip          = false
     base64_encode = false

     part {
         content_type = "text/x-shellscript"
         content = file("${path.module}/user_data.sh")
     }

     part {
          content_type = "text/cloud-config"
          content = data.template_file.init-script.rendered
     }
}

resource "aws_instance" "host" {
         ami = var.ami
         instance_type = var.instance_type
         tags = var.tags
         key_name = var.keypair_name
         user_data = data.template_cloudinit_config.cloudinit.rendered
         network_interface {
            network_interface_id = aws_network_interface.intf.id
            device_index = 0
         }
}
