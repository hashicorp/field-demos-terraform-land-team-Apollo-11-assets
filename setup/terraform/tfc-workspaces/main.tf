//TFC VCS and Workspaces
resource "tfe_oauth_client" "test-oauth-client" {
   organization = var.TFC_ORGANIZATION
   api_url          = "http://${var.GITLAB_PUBLIC_ADDRESS}/api/v4"
   http_url         = "http://${var.GITLAB_PUBLIC_ADDRESS}/"
   oauth_token      = var.GITLAB_TOKEN
   service_provider = "gitlab_community_edition"
}

resource "tfe_workspace" "hashicups_prod" {
  name         = "hashicups-prod"
  organization = var.TFC_ORGANIZATION
  auto_apply = true
  terraform_version = "0.14.9"
  vcs_repo {
    identifier = "hashicups-development-team/hashicups-application"
    branch = "master"
    oauth_token_id     = tfe_oauth_client.test-oauth-client.oauth_token_id
  }
}

resource "tfe_workspace" "hashicups_stage" {
  name         = "hashicups-staging"
  organization = var.TFC_ORGANIZATION
  auto_apply = true
  terraform_version = "0.14.9"
  vcs_repo {
    identifier = "hashicups-development-team/hashicups-application"
    branch = "stage"
    oauth_token_id     = tfe_oauth_client.test-oauth-client.oauth_token_id
  }
}

resource "tfe_workspace" "hashicups_dev" {
  name         = "hashicups-dev"
  organization = var.TFC_ORGANIZATION
  auto_apply = true
  terraform_version = "0.14.9"
  vcs_repo {
    identifier = "HashiCups-Development-Team/hashicups-application"
    branch = "development"
    oauth_token_id     = tfe_oauth_client.test-oauth-client.oauth_token_id
  }
}

resource "tfe_variable" "prod_aws_access_key" {
  key = "AWS_ACCESS_KEY_ID"
  value = var.AWS_ACCESS_KEY_ID
  category = "env"
  sensitive = true
  workspace_id = tfe_workspace.hashicups_prod.id
}

resource "tfe_variable" "prod_aws_secret_key" {
  key = "AWS_SECRET_ACCESS_KEY"
  value = var.AWS_SECRET_ACCESS_KEY
  category = "env"
  sensitive = true
  workspace_id = tfe_workspace.hashicups_prod.id
}

resource "tfe_variable" "prod-region" {
  key = "region"
  value = "us-west-2"
  category = "terraform"
  sensitive = false
  workspace_id = tfe_workspace.hashicups_prod.id
}

resource "tfe_variable" "prod_environment" {
  key = "environment"
  value = "production"
  category = "terraform"
  sensitive = false
  workspace_id = tfe_workspace.hashicups_prod.id
}

resource "tfe_variable" "stage_aws_access_key" {
  key = "AWS_ACCESS_KEY_ID"
  value = var.AWS_ACCESS_KEY_ID
  category = "env"
  sensitive = true
  workspace_id = tfe_workspace.hashicups_stage.id
}

resource "tfe_variable" "stage_aws_secret_key" {
  key = "AWS_SECRET_ACCESS_KEY"
  value = var.AWS_SECRET_ACCESS_KEY
  category = "env"
  sensitive = true
  workspace_id = tfe_workspace.hashicups_stage.id
}

resource "tfe_variable" "stage_region" {
  key = "region"
  value = "us-west-2"
  category = "terraform"
  sensitive = false
  workspace_id = tfe_workspace.hashicups_stage.id
}

resource "tfe_variable" "stage_environment" {
  key = "environment"
  value = "stage"
  category = "terraform"
  sensitive = false
  workspace_id = tfe_workspace.hashicups_stage.id
}

resource "tfe_variable" "dev_aws_access_key" {
  key = "AWS_ACCESS_KEY_ID"
  value = var.AWS_ACCESS_KEY_ID
  category = "env"
  sensitive = true
  workspace_id = tfe_workspace.hashicups_dev.id
}

resource "tfe_variable" "dev_aws_secret_key" {
  key = "AWS_SECRET_ACCESS_KEY"
  value = var.AWS_SECRET_ACCESS_KEY
  category = "env"
  sensitive = true
  workspace_id = tfe_workspace.hashicups_dev.id
}

resource "tfe_variable" "dev_region" {
  key = "region"
  value = "us-west-2"
  category = "terraform"
  sensitive = false
  workspace_id = tfe_workspace.hashicups_dev.id
}

resource "tfe_variable" "dev_environment" {
  key = "environment"
  value = "development"
  category = "terraform"
  sensitive = false
  workspace_id = tfe_workspace.hashicups_dev.id
}

output "oauth_token_id" {
  value = tfe_oauth_client.test-oauth-client.oauth_token_id
}
