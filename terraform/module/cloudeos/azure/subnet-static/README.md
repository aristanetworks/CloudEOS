# README

subnet-static module is using existing Azure Subnets instead of creating the new resources.

Example of usage:
```sh
subnet_info = {
  edge1subnet : {
    subnet_names    = ["edge1Subnet0", "edge1Subnet1", "edge1Subnet2", "edge1Subnet3", "edge1Subnet4"]
  }
}

module "edge1Subnet" {
  source          = "../../../module/cloudeos/azure/subnet-static"
  subnet_names    = var.subnet_info["edge1subnet"]["subnet_names"]
  vnet_name       = module.edge1.vnet_name
  vnet_id         = module.edge1.vnet_id
  rg_name         = module.edge1.rg_name
  topology_name   = module.edge1.topology_name
}
```

