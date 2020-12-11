# README

rg-static module is using existing Azure Resource Group and VNET instead of creating the new resources.

Example of usage:
```sh
# Add this variable to input_vars.tfvars file
static_rg_vnet_info = {
  edge1: {
    rg = "hub-rg"
    vnet = "hub_vnet"
  }
  azureLeaf1: {
    rg = "spoke1_rg"
    vnet = "spoke1_vnet"
  }
  azureLeaf2: {
    rg = "spoke2_rg"
    vnet = "spoke2_vnet"
  }
}

# Following should be added to .tf file
module "edge1" {
  source        = "../../../module/cloudeos/azure/rg-static"
  nsg_name      = "${var.topology}edge1Nsg"
  role          = "CloudEdge"
  rg_eos_name   = var.static_rg_vnet_info["edge1"]["rg"]
  vnet_name     = var.static_rg_vnet_info["edge1"]["vnet"]
  topology_name = cloudeos_topology.topology.topology_name
  clos_name     = cloudeos_clos.clos.name
  wan_name      = cloudeos_wan.wan.name
  tags = {
    Name = "${var.topology}edge1"
  }
  availability_set = true
}
```

