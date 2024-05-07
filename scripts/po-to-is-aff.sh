#!/bin/bash

# il y a des po:present ou po:1sg dans les définitions d'affixes. ça correspond moins à un part-of-speech qu'à des informations d'inflexion, à mon avis (et c'est comme ça que je vais les utiliser), donc je remplace par 'is:...' (inflectional suffix).

file="$1"
# exit s'il n'y a pas de fichier
if ! [ -f "$file" ]; then echo 'no file, exit.'; exit 1; fi

# pour éviter les erreurs, ce script ne peut être utilisé que sur les fichiers .aff
if ! [[ "$file" =~ \.aff$ ]]; 
then 
    echo 'script pour les affixes!'
    exit 1
fi

sed -i -E -e 's/po:'
