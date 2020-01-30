#!/bin/sh

tfstateDirList='
/app/my-terraform/providers/aws/environments/10-network
/app/my-terraform/providers/aws/environments/10-ssm
/app/my-terraform/providers/aws/environments/11-ecr
/app/my-terraform/providers/aws/environments/20-api
'

for tfstateDir in ${tfstateDirList}; do
  echo "$tfstateDir"
  # shellcheck disable=SC2164
  cd "$tfstateDir"
  pwd
  terraform init
  terraform workspace select dev
  terraform workspace list
done
