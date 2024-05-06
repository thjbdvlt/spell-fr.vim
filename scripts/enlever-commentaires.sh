#!/bin/bash

# enlever les commentaires des fichiers .dic et .aff afin de pouvoir rapidifier la compilation avec vim. c'est le script inverse de 'decommenter.sh', qui est destiné à d'autres usages que vim.
root=$(git rev-parse --show-toplevel)

if ! [ -f "$1" ];then echo "no file!"; exit 1; fi

sed -E -i 's|\s*#.*||' "$1"
