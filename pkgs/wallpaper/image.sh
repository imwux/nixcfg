#!/usr/bin/env nix-shell
#!nix-shell -i bash -p jq httpie

image="$(echo "$1" | rev | cut -d '/' -f1 | rev | cut -d '.' -f1)"
clientid="2017063848dc22d"

image=$(https api.imgur.com/3/image/$image Authorization:"Client-ID $clientid" | jq -r '.data | "\(.description)|\(.type)|\(.id)"')

name=$(echo $image | cut -d '|' -f 1)
ext=$(echo $image | cut -d '|' -f 2 | cut -d '/' -f 2)
id=$(echo $image | cut -d '|' -f 3)
hash=$(nix-prefetch-url https://i.imgur.com/$id.$ext)

jq -n --arg name "$name" --arg ext "$ext" --arg id "$id" --arg sha256 "$hash" '{"name": $name, "ext": $ext, "id": $id, "sha256": $sha256}'
