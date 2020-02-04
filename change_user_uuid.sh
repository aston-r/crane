#!/bin/bash

# Fail on any '$? > 0'
set -o errexit

user_name="${1}"
if [[ -n "${user_name}" ]]; then
    if [[ "$(getent 'passwd' "${user_name}")" ]]; then
        source_uid="$(getent 'passwd' | awk -F: -v entity_name="${user_name}" "\$1==entity_name { print \$3; }")"
        target_uid="$(getent 'passwd' | awk -F: '($3>1) && ($3<10000) && ($3>maxuid) { maxuid=$3; } END { print maxuid+1; }')"

        echo "Changing the UID of user ${user_name} from ${source_uid} to ${target_uid}"
    fi
else
    echo "User with '${user_name}' does not exist!"
    exit 1
fi

