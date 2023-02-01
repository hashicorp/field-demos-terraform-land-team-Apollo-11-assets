# Copyright (c) HashiCorp, Inc.
# SPDX-License-Identifier: MPL-2.0

//Gitlab Projects
provider "gitlab" {
    base_url = "http://${var.GITLAB_PUBLIC_ADDRESS}/api/v4"
}

//Dev
resource "gitlab_group" "devteam" {
  name        = "HashiCups Development Team"
  path        = "HashiCups-Development-Team"
  visibility_level = "public"
}

resource "gitlab_project" "app" {
  name         = "HashiCups Application"
  namespace_id = gitlab_group.devteam.id
  visibility_level = "public"
}

resource "gitlab_project" "modapp" {
  name         = "HashiCups Application Module"
  namespace_id = gitlab_group.devteam.id
  visibility_level = "public"
}

//DB
resource "gitlab_group" "datateam" {
  name        = "Database Team"
  path        = "Database-Team"
  visibility_level = "public"
}

resource "gitlab_project" "data" {
  name         = "Terraform AWS Postgres RDS Module"
  namespace_id = gitlab_group.datateam.id
  visibility_level = "public"
  tags = [tostring(1.1)]
}

//Server
resource "gitlab_group" "serverteam" {
  name        = "Server Team"
  path        = "Server-Team"
  visibility_level = "public"
}

resource "gitlab_project" "server" {
  name         = "Terraform AWS Server Module"
  namespace_id = gitlab_group.serverteam.id
  visibility_level = "public"
  tags = [tostring(2.4)]
}

//Network
resource "gitlab_group" "netteam" {
  name        = "Network Team"
  path        = "Network-Team"
  visibility_level = "public"
}

resource "gitlab_project" "network" {
  name         = "Terraform AWS Network Module"
  namespace_id = gitlab_group.netteam.id
  visibility_level = "public"
  tags = [tostring(1.6)]
}

//Sentinel
resource "gitlab_group" "sentinel" {
  name        = "Security Team"
  path        = "Security-Team"
  visibility_level = "public"
  description = "Group to manage Sentinel Policies"
}

resource "gitlab_project" "sentinel" {
  name         = "Sentinel Policies"
  visibility_level = "public"
  namespace_id = gitlab_group.sentinel.id
}
