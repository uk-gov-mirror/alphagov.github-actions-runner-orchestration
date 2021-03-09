#!/usr/bin/env bash

while true; do
  sleep 30

  EXPIRY=$(aws ec2 describe-tags \
    --filters "Name=resource-id,Values=$INSTANCE_ID" \
    --region "eu-west-2" \
    | jq -r '.Tags | .[] | select(.Key == "GitHubRunnerTimeout").Value')

  cd "/opt/github/runner" || exit 1

  if (( EXPIRY < $(date +%s) )); then
    echo "------------------"
    echo "Shutting down, expiry was: $EXPIRY"
    echo "------------------"
    sleep 20 && sudo shutdown -h now &
    ./remove-svc.sh "$REPO"
  fi
done
