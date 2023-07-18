#!/bin/sh
set -e

VAR=python3
docker build -t $VAR ./app 
terraform apply -var="image_name=$VAR" -auto-approve

set +e
