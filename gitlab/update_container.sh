#!/bin/bash

set -e

### I don't know why but this is not working when running the script via SSH
# SCRIPT_DIR=$( cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )
# echo $SCRIPT_DIR

## Gitlab Project ID
PROJECT_ID=$1

## Gitlab Personal Access Token (Generated on Gitlab > Preferences > Access Tokens)
PERSONAL_ACCESS_TOKEN=$2

## Container name - Usually is the repository name
CONTAINER_NAME=$3

## The image name on the Registry
IMAGE_NAME=$4

## Service port
SERVICE_PORT=$5

## Panel port
PANEL_PORT=$6

## Boolean. Set to true if it is the first time running the container
FIRST_TIME=$7

# SHA=$(sh $SCRIPT_DIR/last_tag.sh $PROJECT_ID $PERSONAL_ACCESS_TOKEN)
SHA=$(sh ~/repos/uranio-cicd/gitlab/last_tag.sh $PROJECT_ID $PERSONAL_ACCESS_TOKEN)

echo "Last sha: ${SHA}"

echo "Docker system prune -af ..."
docker system prune -af

if [ -z $FIRST_TIME ]; then
	echo "Stopping and deleteing ${CONTAINER_NAME}..."
	docker stop $CONTAINER_NAME && docker rm $CONTAINER_NAME
fi

# -v /home/ec2-user/.certs/$CONTAINER_NAME/:/app/cert/ \
echo "Running ${CONTAINER_NAME} ${IMAGE_NAME}:${SHA}..."
docker run -t -d -p $SERVICE_PORT:$SERVICE_PORT -p $PANEL_PORT:$PANEL_PORT \
	--env-file ~/.envs/$CONTAINER_NAME.env \
	--name $CONTAINER_NAME \
	$IMAGE_NAME:$SHA
