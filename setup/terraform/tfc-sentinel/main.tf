resource "tfe_policy_set" "awsssh" {
  name          = "CIS-Benchmarks-4_1-Networking"
  description   = "CIS Benchmarks 4.1"
  organization  = var.TFC_ORGANIZATION
  policies_path = "/aws/networking/aws-cis-4.1-networking-deny-public-ssh-acl-rules"
  global = true

  vcs_repo {
    identifier         = "Security-Team/sentinel-policies"
    branch             = "master"
    ingress_submodules = false
    oauth_token_id     = var.OAUTH_TOKEN_ID
  }
}
