
# Update Input variables
Before deploying resources look at the input parameters passed to terraform like ami,
instance_type, regions etc.

File containing input parameters: **input_vars.tfvars**

You can update the values based on your requirement. Make sure you change the topology name
so it doesn't collide with others !

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

