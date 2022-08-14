#!/bin/bash

set -e

SCRIPT_DIR=$( cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )

## Gitlab Project ID
PROJECT_ID=$1

## Gitlab Personal Access Token (Generated on Gitlab > Preferences > Access Tokens)
PERSONAL_ACCESS_TOKEN=$2

SHA=$(sh $SCRIPT_DIR/tags.sh $PROJECT_ID $PERSONAL_ACCESS_TOKEN | head -n 1)
echo $SHA

# readarray -t ARRSHA <<<"$SHA"
# echo $ARRSHA
