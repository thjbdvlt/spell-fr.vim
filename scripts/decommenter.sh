#!/bin/bash

# enlever les "#" qui commentent certaines parties des fichiers .dic et .aff: les parties qui contiennent les informations morphologiques et grammaticales, non supportées par vim et qui produise des erreurs et/ou amènent à des lignes manquantes lors de la compilation.
root=$(git rev-parse --show-toplevel)
sed -i -E 's/(\w+.*)#(.*$)/\1 \2/' ${root}/st.dic ${root}/st.aff
