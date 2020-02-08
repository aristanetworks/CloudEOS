
module "globals" {
  source = "../common"
}

provider "aws" {
  region = "${module.globals.aws_regions["region1"]}"
}

provider "arista" {
  cvaas_domain = "${module.globals.cvaas["domain"]}"
  cvaas_username = "${module.globals.cvaas["username"]}"
  cvaas_server = "${module.globals.cvaas["server"]}"
  service_account_web_token = "${module.globals.cvaas["service_token"]}"
}

