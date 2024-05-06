#!/bin/bash

# ajoute en haut d'un fichier: son nombre de lignes.

file="$1"

if ! [ -f "$file" ];then exit 1; fi

sed -i "1s/^/$(wc -l "$file" | cut -d ' ' -f 1)\n/" "$file"
