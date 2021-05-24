
*Please read the main [README](../../README.md) to go over the steps to setup your environment and deploy this example topology.*

# Topology Overview

**Note that this feature requires atleast version 1.1.2 of the cloudeos provider and the modules**

Provision mode - Rather than have cvp deploy and manage an entire fabric (by generating and pushing config on the cloudeos devices
once they're onboarded to cvp), this 'Provision Deployment Mode' allows you to onboard individual routers and configure them.
The cloudeos instances are onboarded to cvp (mapped to the specified container, followed by a reconcile). Creating the topology
(by configuring the cloudeos instances) is upto the user. Things to remember about this mode:

- This mode is activated by specifying deploy_mode="provision" in the cloudeos_topology resource.
- Topology specific vars (such as is_rr) or ones that aided in the construction of the topology (various cidr blocks) don't make
  sense in this mode and are not necessary. Specifying them will cause the provider to return appropriate errors signalling the
  same or the specified var shall simply be ingored.
- Not specifying the deploy_mode var (or setting it as empty) indicates the standard deployment mode, wherein a full fabric
  is being deployed and managed by the multi cloud solution.
- There are no resources with role CloudLeaf (vpc or router). All resources MUST have the role set to edge.
- The routers are onboarded with the bare minimum config to intergrate them into cvp. Configuration shall be supplied by the user
  (manually or though some form of automation - Eg - cvp ansible integration).
- A consequence of the user specifying and managing the topology is that before a cloudeos instance can be destroyed via terraform,
  any changes on any affected peers MUST be done before the destroy. As an example, DPS paths are setup between edges in different
  regions in the standard deployment mode. When a router is deleted by invoking a terraform destroy, cvp goes and looks at the
  affected peers and starts updating their config to remove the To Be Deleted router (bgp peering and dps path-group config). In
  this mode, since the overall topology is not known, so any config changes must be taken care of, before destroying resources.
- The mode is applicable to all routers created within a topology. There is no mixing and matching of resources with different
  deployment modes.

Deployment of 1 cloudeos instance in a vnet in azure + 2 cloudeos instances in a vpc each in aws in Provision Deployment Mode
is demonstrated in this example.
