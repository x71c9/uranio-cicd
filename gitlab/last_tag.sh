#!/bin/bash

set -e

## Gitlab Project ID
PROJECT_ID=$1

## Gitlab Personal Access Token (Generated on Gitlab > Preferences > Access Tokens)
PERSONAL_ACCESS_TOKEN=$2

URL="https://gitlab.com/api/v4/projects/${PROJECT_ID}/registry/repositories?tags=true"
HEADER="Authorization: Bearer ${PERSONAL_ACCESS_TOKEN}"

RESULT=$(curl -s --request GET --url "${URL}" --header "${HEADER}")

REPOSITORY_ID=$(echo "${RESULT}" | jq -rc '.[0].id')

TAGS=$(echo "${RESULT}" | jq -rc '.[0].tags' | jq -rc '.[]')

MAX_DATE=$(date -d 1970-01-01 +%s)
LAST_TAG='latest'

## Gitlab has no API for getting all the tags with the `created_at` attribute
## A single call for each Tag must be done in order to get the `created_at` attr.
for row in $TAGS; do
        TAG_NAME=$(echo $row | jq -rc '.name')
        TAG_URL="https://gitlab.com/api/v4/projects/${PROJECT_ID}/registry/repositories/${REPOSITORY_ID}/tags/${TAG_NAME}"
        TAG_DATE=$(curl -s --request GET --url "${TAG_URL}" --header "${HEADER}" | jq -rc '.created_at')
        INT_DATE=$(date -d $TAG_DATE +%s)
        if [ $INT_DATE -ge $MAX_DATE ];
        then
                MAX_DATE=$INT_DATE
                LAST_TAG=$TAG_NAME
        fi
done

echo $LAST_TAG
