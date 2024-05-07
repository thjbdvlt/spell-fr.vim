#!/bin/bash

# enlever les "#" qui commentent certaines parties des fichiers .dic et .aff: les parties qui contiennent les informations morphologiques et grammaticales, non supportées par vim et qui produise des erreurs et/ou amènent à des lignes manquantes lors de la compilation.

# nécessite un fichier
if ! [ -f "$1" ];then echo "no file!"; exit 1; fi

# décommente tout simplement (sauf les commentaires qui commencent en début de ligne).
sed -i -E 's/(\w+.*)#(.*$)/\1 \2/' "$1"
