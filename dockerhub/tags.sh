#!/bin/bash

set -e

# Example for the Docker Hub V2 API
# Returns all imagas and tags associated with a Docker Hub user account.
# Requires 'jq': https://stedolan.github.io/jq/

## DockerHub Username
UNAME=$1

## DockerHub Access Token (Generated in DockerHub > Account Settings > Security > Access Token)
UPASS=$2

## DockerHub Repo
REPO=$3

TOKEN=$(curl -s -H "Content-Type: application/json" -X POST -d '{"username": "'${UNAME}'", "password": "'${UPASS}'"}' https://hub.docker.com/v2/users/login/ | jq -r .token)

IMAGE_TAGS=$(curl -s -H "Authorization: JWT ${TOKEN}" https://hub.docker.com/v2/repositories/${UNAME}/${REPO}/tags/ | jq -r '.results|.[]|.name')

for j in ${IMAGE_TAGS}
do
	echo ${j}
done
