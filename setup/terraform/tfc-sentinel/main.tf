# Copyright (c) HashiCorp, Inc.
# SPDX-License-Identifier: MPL-2.0

resource "tfe_policy_set" "pmr" {
  name          = "require-all-resources-from-pmr"
  description   = "Requires all non-root modules come from the private module registry and prevents creation of resources in the root module"
  organization  = var.TFC_ORGANIZATION
  policies_path = "/cloud-agnostic/pmr"
  global = true

  vcs_repo {
    identifier         = "Security-Team/sentinel-policies"
    branch             = "master"
    ingress_submodules = false
    oauth_token_id     = var.OAUTH_TOKEN_ID
  }
}
