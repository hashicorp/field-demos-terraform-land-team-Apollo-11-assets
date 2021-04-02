#!/bin/bash
cd ~/gitclones
git config --global user.name "root" > /dev/null 2>&1
git config --global user.email demo@hashicorp.com > /dev/null 2>&1

# Modify 'hashicup-application-module' with GitLab Public Address
cat ~/gitclones/hashicups-application-module/main.tf | grep UPDATEME > /dev/null 2>&1
if [ "$?" == 0 ] ; then
  sed -i -e "s/UPDATEME/${GITLAB_PUBLIC_ADDRESS}/g" ~/gitclones/hashicups-application-module/main.tf
  cd ~/gitclones/hashicups-application-module/
  git config --global user.name "root" > /dev/null 2>&1
  git config --global user.email demo@hashicorp.com > /dev/null 2>&1
  git add . > /dev/null 2>&1
  git commit -m "Updated GitLab IP" > /dev/null 2>&1
  git push http://root:$GITLAB_PASSWORD@$GITLAB_PUBLIC_ADDRESS/hashicups-development-team/hashicups-application-module > /dev/null 2>&1
fi

# Push Projects repos
for x in hashicups-development-team/hashicups-application hashicups-development-team/hashicups-application-module network-team/terraform-aws-network-module database-team/terraform-aws-postgres-rds-module server-team/terraform-aws-server-module security-team/sentinel-policies; do
  IFS='/'
  read -a strarr<<< $x
  cd ~/gitclones/${strarr[1]}
  rm -Rf .git
  git init
  git config http.postBuffer 524288000 #~502 errors
  git remote add origin http://$GITLAB_PUBLIC_ADDRESS/${strarr[0]}/${strarr[1]}.git
  git add .
  git commit -m "First commit"
  git tag -a v$((RANDOM % 10)).$((RANDOM % 10)).0 -m "Create Tag"
  git push http://root:$GITLAB_PASSWORD@$GITLAB_PUBLIC_ADDRESS/${strarr[0]}/${strarr[1]}.git
  git push --tags http://root:$GITLAB_PASSWORD@$GITLAB_PUBLIC_ADDRESS/${strarr[0]}/${strarr[1]}.git
  git branch stage
  git push http://root:$GITLAB_PASSWORD@$GITLAB_PUBLIC_ADDRESS/${strarr[0]}/${strarr[1]}.git stage
  git branch development
  git push http://root:$GITLAB_PASSWORD@$GITLAB_PUBLIC_ADDRESS/${strarr[0]}/${strarr[1]}.git development
  cd ..
done
