#!/bin/bash

# dump la liste de tous les mots possibles
root=$(git rev-parse --show-toplevel)
cd ${root}
unmunch st.dic st.aff | sed -E 's@/|$@@' | sort | uniq > all_words.txt
