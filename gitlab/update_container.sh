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

## Boolean. Set to true if it is the first time running the container
FIRST_TIME=$5

# SHA=$(sh $SCRIPT_DIR/last_tag.sh $PROJECT_ID $PERSONAL_ACCESS_TOKEN)
SHA=$(sh ~/repos/uranio-cicd/gitlab/last_tag.sh $PROJECT_ID $PERSONAL_ACCESS_TOKEN)

echo "Last sha: ${SHA}"

echo "Docker system prune -af ..."
docker system prune -af

if [ -z $FIRST_TIME ]; then
        echo "Stopping and deleteing ${CONTAINER_NAME}..."
        docker stop $CONTAINER_NAME && docker rm $CONTAINER_NAME
fi

echo "Running ${CONTAINER_NAME} ${IMAGE_NAME}:${SHA}..."
docker run -t -d -p 80:80 -p 443:443 -p 7777:7777\
	--env-file ~/.envs/$CONTAINER_NAME.env \
	-v /home/ec2-user/.certs/$CONTAINER_NAME/:/app/cert/ \
	--name $CONTAINER_NAME \
	$IMAGE_NAME:$SHA
