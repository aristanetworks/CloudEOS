
# Update Input variables
Before deploying resources look at the input parameters passed to terraform like ami,
instance_type, regions etc.

File containing input parameters: **input_vars.tfvars**

You can update the values based on your requirement. 

Make sure you change the following so it doesn't collide with others !
- Topology name 
- vtep_ip_cidr   - CIDR block for VTEP IPs 
- terminattr_ip_cidr -  IP range for terminattr source
- dps_controlplane_cidr -  Block for Dps Control Plane IPs 
- keypairs to login to the router

These fields are commented out in input_vars.tfvars. Please uncomment them and modify them appropriately. Otherwise terraform plan execution will prompt for various inputs.

**Please dont forget to udpate [CloudEOS SE MultiCloud POC CIDR Reservations](https://docs.google.com/spreadsheets/d/1HkANmxzbowQlqqQHdI2e8qcZ1LqY7QDaTnr-BofdhLg/edit?usp=sharing "CloudEOS SE MultiCloud POC CIDR Reservations") with the CIDRS you are using. If you leave it with defaults it results in undefined behavior and will have to destroy on conflicting resources and recreate all affected topologies.**

# Create Topology, Route Reflector, Edge and Leaf Routers

It's necessary to create resources in the following order.
1. Topology and Route Reflector
2. Edge
3. Leaf

# For MAC OS
1. To create Topology and Route Reflector

Assuming current directory to be this directory. Execute to below commands to
create topology and route reflector.

```bash
cd topology
terraform init --plugin-dir=../../../.terraform/plugins/darwin_amd64/
terraform plan -var-file=../input_vars.tfvars
terraform apply -var-file=../input_vars.tfvars
```

2. To create Edge resources
Assuming current directory to be this directory.

```bash
cd edge
terraform init --plugin-dir=../../../.terraform/plugins/darwin_amd64/
terraform plan -var-file=../input_vars.tfvars
terraform apply -var-file=../input_vars.tfvars
```

3. To create Leaf resources
Assuming current directory to be this directory.

```bash
cd leaf
terraform init --plugin-dir=../../../.terraform/plugins/darwin_amd64/
terraform plan -var-file=../input_vars.tfvars
terraform apply -var-file=../input_vars.tfvars
```

**Don't forget to terraform destroy..see steps at the end**

# For Linux 
1. To create Topology and Route Reflector

Assuming current directory to be this directory. Execute to below commands to
create topology and route reflector.

```bash
cd topology
terraform init --plugin-dir=../../../.terraform/plugins/linux_amd64/
terraform plan -var-file=../input_vars.tfvars
terraform apply -var-file=../input_vars.tfvars
```

2. To create Edge resources
Assuming current directory to be this directory.

```bash
cd edge
terraform init --plugin-dir=../../../.terraform/plugins/linux_amd64/
terraform plan -var-file=../input_vars.tfvars
terraform apply -var-file=../input_vars.tfvars
```

3. To create Leaf resources

Assuming current directory to be this directory.

```bash
cd leaf
terraform init --plugin-dir=../../../.terraform/plugins/linux_amd64/
terraform plan -var-file=../input_vars.tfvars
terraform apply -var-file=../input_vars.tfvars
```

# To destroy resources

It's necessary to destroy in following order

1. Destory Leaf resources

```bash
terraform destroy -var-file=../input_vars.tfvars
```

2. Destory Edge resources

```bash
terraform destroy -var-file=../input_vars.tfvars
```

3. Destory Topology and Route Reflector resources

```bash
terraform destroy -var-file=../input_vars.tfvars
```

