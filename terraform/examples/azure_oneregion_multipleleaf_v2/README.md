
*Please read the main [README](../../README.md) to go over the steps to setup your environment and deploy this example topology.*

# Topology overview

* This topology is functionally equivalent to "azure_oneregion_multipleleaf".
* It requires additional information about Azure subscription (such as subscription_id, tenant_id etc) to be specified in the input_vars.tfvars and is meant to be used only in the case when authentication using the azure cli is not available on a given machine.
* The username and password to be configured on the cloudEOS instances is also specified  in the input_vars.tfvars file.

![Topology](../azure_oneregion_multipleleaf/Azure_One_Region_Multiple_Leaf.png)
