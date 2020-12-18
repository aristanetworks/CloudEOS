* This topology is functionally equivalent to "azure_oneregion_multipleleaf".
* It requires additional information about Azure subscription (such as subscription_id,
  tenant_id etc) to be specified in the input_vars.tfvars and is meant to be used only
  in the case when authentication using the azure cli is not available on a given machine.
* The username and password to be configured on the cloudEOS instances is also specified
  in the input_vars.tfvars file.

