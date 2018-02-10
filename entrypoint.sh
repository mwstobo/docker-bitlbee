#!/bin/ash

export USER_NAME=${LOCAL_USER_NAME:-bitlbee}
export USER_GROUP=${LOCAL_USER_GROUP:-$USER_NAME}
export USER_ID=${LOCAL_USER_ID:-9001}
export GROUP_ID=${LOCAL_GROUP_ID:-$USER_ID}

addgroup -g "$GROUP_ID" "$USER_GROUP"
adduser -S -s /bin/ash -u "$USER_ID" -G "$USER_GROUP" "$USER_NAME"

exec "$@"
