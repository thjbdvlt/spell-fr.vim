#!/bin/bash

# enlever les commentaires des fichiers .dic et .aff afin de pouvoir rapidifier la compilation avec vim. c'est le script inverse de 'decommenter.sh', qui est destiné à d'autres usages que vim.
root=$(git rev-parse --show-toplevel)

sed -E -i 's|\s*#.*||' ${root}/st.dic ${root}/st.aff
