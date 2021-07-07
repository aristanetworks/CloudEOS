Arista CloudEOS™ Multi Cloud solution enables a highly secure and reliable networking experience with consistent segmentation, telemetry, provisioning and troubleshooting for the entire enterprise. It can be deployed across the enterprise edge, WAN, campus, data center, and multiple public and private clouds. For more information, please visit [Arista CloudEOS webpage](https://www.arista.com/en/solutions/hybrid-cloud) and [CloudEOS product brief](https://www.arista.com/assets/data/pdf/Whitepapers/Arista_CloudEOS_Product_Brief.pdf). Please contact sales@arista.com for any questions.

The `terraform` folder has pre-built Terraform scripts to create network topologies in AWS and Azure using CloudEOS.

The modules are versioned and specify the minimum provider versions that they depend on. It is recommended that the
latest release be used (available as a tar.gz in the releases section). Running a terraform init in any of the examples
will download all the providers.

Any backwards incompatible changes between versions (that may require some manual steps, such as modifying the state files via
terraform state mv or terraform state rm) are always doumented in UPGRADE.md. We recommend that users always check out them out
before upgrading the modules. Minor releases will almost always never introduce backward incompatible changes.
