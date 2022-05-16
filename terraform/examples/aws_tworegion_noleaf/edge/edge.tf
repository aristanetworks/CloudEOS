// Copyright (c) 2020 Arista Networks, Inc.
// Use of this source code is governed by the Apache License 2.0
// that can be found in the LICENSE file.
module "globals" {
  source            = "../../../module/cloudeos/common"
  topology          = var.topology
  keypair_name      = var.keypair_name
  cvaas             = var.cvaas
  instance_type     = var.instance_type
  aws_regions       = var.aws_regions
  eos_amis          = local.eos_amis
  availability_zone = var.availability_zone
  host_amis         = var.host_amis
}

provider "cloudeos" {
  cvaas_domain              = module.globals.cvaas["domain"]
  cvaas_server              = module.globals.cvaas["server"]
  service_account_web_token = module.globals.cvaas["service_token"]
}
