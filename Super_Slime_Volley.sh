#!/bin/sh
printf '\033c\033]0;%s\a' Super Slime Volley
base_path="$(dirname "$(realpath "$0")")"
"$base_path/Super_Slime_Volley.x86_64" "$@"
