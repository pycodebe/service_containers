#!/bin/bash

set -e

echo "# ---------------------------------------------"
echo "# Doing some cleanup of the configuration file"
echo

keys_to_delete=("global\/api_keys" "global\/servers" "global\/server_groups")

for key in "${keys_to_delete[@]}"
do
    sed -i "/^$key/d" $1
    key=${key//"\\"/""}
    echo "Section $key deleted"
done

echo

echo "# ---------------------------------------------"
echo "# Save the last status of the job(s)" in notes
echo
sed -i "/^global\/schedule\/0/s/\"enabled\":1/\"enabled\":0/" $1
echo "Scheduled job(s) has/have been disabled"

echo

