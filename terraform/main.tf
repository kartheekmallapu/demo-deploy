provider "aws" {
  alias  = "apac_shd"
  region = "ap-southeast-2"

  assume_role {
    role_arn = "arn:aws:iam::464902759691:role/orica-vault-poweruser-role"
  }
}


provider "aws" {
  alias  = "apac_prd"
  region = "ap-southeast-2"

  assume_role {
    role_arn = "arn:aws:iam::052578022106:role/orica-vault-poweruser-role"
  }
}

terraform {
  backend "s3" {
    bucket         = "orica-global-prd-terraform"
    key            = "instances/testdeploy01/terraform.tfstate"
    region         = "ap-southeast-2"
    dynamodb_table = "orica-global-prd-terraform-state-lock"
    encrypt        = true
    role_arn       = "arn:aws:iam::464902759691:role/orica-vault-admin-role"
  }
}

variable "admin_username" {
  type    = string
  default = ""
}

variable "admin_password" {
  type    = string
  default = ""
}

/*
module "soe02" {
  providers = {
    aws = aws.apac_shd
  }

  admin_username = var.admin_username
  admin_password = var.admin_password

  source               = "git@gitlab.com:orica/terraform-modules/aws-orica-ec2.git"
  host_name            = "support.test.shd"
  instance_type        = "t3a.medium"
  is_soe               = "true"
  os                   = "windows-2016"
  subnet_name          = "PRD-APP-AZ1-SN"
  security_group_names = ["PRD-INFRA-ICMP-SG", "PRD-INFRA-RDP-SG", "PRD-RemoteAutomationMgmt-APP-SG"]
  key_name             = "tf-keypair"
  description          = "VM Description"

  tags = {
    "tag2" = "eg2"
    "tag3" = "eg3"
  }
}
*/

module "soe01" {
  providers = {
    aws = aws.apac_prd
  }

  admin_username = var.admin_username
  admin_password = var.admin_password

  source               = "git@gitlab.com:orica/terraform-modules/aws-orica-ec2.git"
  host_name            = "support.test.shd"
  instance_type        = "t3a.medium"
  is_soe               = "true"
  os                   = "windows-2016"
  subnet_name          = "PRD-CETST-AZ1-SN"
  security_group_names = ["TST-CE-CUTOVER-SGT"]
  key_name             = "tf-keypair"
  description          = "VM Description"

  tags = {
    "tag2" = "eg2"
    "tag3" = "eg3"
  }
}
