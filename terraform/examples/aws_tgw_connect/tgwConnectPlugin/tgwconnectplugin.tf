// Copyright (c) 2021 Arista Networks, Inc.
// Use of this source code is governed by the Apache License 2.0
// that can be found in the LICENSE file.

resource "null_resource" "tgw_connect_plugin" {
   provisioner "local-exec" {
      when = create
      command = "./tgw -create"
   }

   provisioner "local-exec" {
      when = destroy
      command = "./tgw -destroy"
   }
}
