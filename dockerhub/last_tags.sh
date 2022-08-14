#!/bin/bash

set -e

# Example for the Docker Hub V2 API
# Returns all imagas and tags associated with a Docker Hub user account.
# Requires 'jq': https://stedolan.github.io/jq/

SCRIPT_DIR=$( cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )

## DockerHub Username
UNAME=$1

## DockerHub Access Token (Generated in DockerHub > Account Settings > Security > Access Token)
UPASS=$2

## DockerHub Repo
REPO=$3

SHA=$(sh $SCRIPT_DIR/tags.sh $UNAME $UPASS $REPO | head -n 1)
echo $SHA

# readarray -t ARRSHA <<<"$SHA"
# echo $ARRSHA
