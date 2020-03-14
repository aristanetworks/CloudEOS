// Copyright (c) 2020 Arista Networks, Inc.
// Use of this source code is governed by the Apache License 2.0
// that can be found in the LICENSE file.
provider "arista" {
  cvaas_domain              = var.cvaas["domain"]
  cvaas_username            = var.cvaas["username"]
  cvaas_server              = var.cvaas["server"]
  service_account_web_token = var.cvaas["service_token"]
}

