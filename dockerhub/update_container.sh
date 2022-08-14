#!/bin/bash

set -e

SCRIPT_DIR=$( cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )

## DockerHub Username
UNAME=$1

## DockerHub Access Token (Generated in DockerHub > Account Settings > Security > Access Token)
UPASS=$2

## DockerHub Repo
REPO=$3

## Container name - Usually is the repository name
CONTAINER_NAME=$3

## The image name on the Registry
IMAGE_NAME=$4

## Boolean. Set to true if it is the first time running the container
FIRST_TIME=$5

SHA=$(sh $SCRIPT_DIR/last_tag.sh $UNAME $UPASS $CONTAINER_NAME)

echo "Last sha: ${SHA}"

echo "Docker system prune -af ..."
docker system prune -af

if [ -z $FIRST_TIME ]; then
	echo "Stopping and deleteing ${CONTAINER_NAME}..."
	docker stop $CONTAINER_NAME && docker rm $CONTAINER_NAME
fi

echo "Running ${CONTAINER_NAME} ${IMAGE_NAME}:${SHA}..."
docker run -t -d -p 80:80 -p 443:443 -p 7799:7799\
	--env-file ~/.envs/$CONTAINER_NAME.env \
	--name $CONTAINER_NAME \
	$IMAGE_NAME:$SHA
