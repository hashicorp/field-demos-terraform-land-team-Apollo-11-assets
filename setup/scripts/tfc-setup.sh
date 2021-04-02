#!/bin/bash

#TFC Organization
clear
echo
echo "Please enter your Terraform Cloud organization name."
read TFC_ORGANIZATION
echo
echo "Running Terraform Login to get TFC credential."
echo
terraform login
echo
echo "Please confirm the below is correct:"
echo
echo "TFC Organization : $TFC_ORGANIZATION"
echo
echo "TFC Credential : $(cat ~/.terraform.d/credentials.tfrc.json)"
echo
read -r -p "Please verify this is correct? [Y/n] " REPLY
echo
if [[ ! $REPLY =~ ^[Yy]$ ]]
then
  echo "Please try again...Reruning ~/setup/scripts/tfc-setup.sh"
  exit 1
fi
echo export TFC_ORGANIZATION=$TFC_ORGANIZATION >> ~/.bashrc
echo export TF_VAR_TFC_ORGANIZATION=$TFC_ORGANIZATION >> ~/.bashrc
echo export TERRAFORM_CONFIG=/root/.terraform.d/credentials.tfrc.json >> ~/.bashrc
echo "Success: TFC organization name and token updated."
