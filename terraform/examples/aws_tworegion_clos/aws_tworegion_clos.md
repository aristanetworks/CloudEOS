
# STEPS

## Change the name of the topology 

change "your-topology-name" in ./common/outputs.tf

output "topology" {
  value = "your-topology-name"
}

## Create topology, edge and then leaf in that order

Change directory to the appropriate directory eg topology

cd topology

### Initialize Terraform 

For Linux 
-----------
terraform init --plugin-dir=../../../.terraform/plugins/linux_amd64/

For MAC
---------
terraform init --plugin-dir=../../../.terraform/plugins/darwin_amd64/

### Terraform plan 

terraform plan -o plan.out

### Terraform apply 

terraform apply --auto-approve
