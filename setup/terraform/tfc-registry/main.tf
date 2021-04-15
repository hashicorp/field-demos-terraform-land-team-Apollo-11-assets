//PMR Modules
resource "tfe_registry_module" "network-registry-module" {
  vcs_repo {
    display_identifier = "network-team/terraform-aws-network-module"
    identifier         = "network-team/terraform-aws-network-module"
    oauth_token_id     = var.OAUTH_TOKEN_ID
  }

}
resource "tfe_registry_module" "server-registry-module" {
  vcs_repo {
    display_identifier = "server-team/terraform-aws-server-module"
    identifier         = "server-team/terraform-aws-server-module"
    oauth_token_id     = var.OAUTH_TOKEN_ID
  }
  depends_on = [ tfe_registry_module.network-registry-module ]
}

resource "tfe_registry_module" "rds-registry-module" {
  vcs_repo {
    display_identifier = "database-team/terraform-aws-postgres-rds-module"
    identifier         = "database-team/terraform-aws-postgres-rds-module"
    oauth_token_id     = var.OAUTH_TOKEN_ID
  }
  depends_on = [ tfe_registry_module.server-registry-module ]
}

//Hashicups-Application-module Workspace
resource "tfe_workspace" "workspace" {
  name = "hashicups-module"
  organization = var.TFC_ORGANIZATION
  auto_apply = false
  terraform_version = "0.14.9"

  vcs_repo {
    identifier = "hashicups-development-team/hashicups-application-module"
    oauth_token_id = var.OAUTH_TOKEN_ID
  }

  depends_on = [ tfe_registry_module.rds-registry-module, tfe_registry_module.server-registry-module ]
}

resource "tfe_variable" "aws_access_key" {
  key = "AWS_ACCESS_KEY_ID"
  value = var.AWS_ACCESS_KEY_ID
  category = "env"
  sensitive = true
  workspace_id = tfe_workspace.workspace.id
}
resource "tfe_variable" "aws_secret_key" {
  key = "AWS_SECRET_ACCESS_KEY"
  value = var.AWS_SECRET_ACCESS_KEY
  category = "env"
  sensitive = true
  workspace_id = tfe_workspace.workspace.id
}

resource "tfe_variable" "region" {
  key = "region"
  value = "us-west-2"
  category = "terraform"
  sensitive = false
  workspace_id = tfe_workspace.workspace.id
}

resource "tfe_variable" "prod_environment" {
  key = "environment"
  value = "production"
  category = "terraform"
  sensitive = false
  workspace_id = tfe_workspace.workspace.id
}
