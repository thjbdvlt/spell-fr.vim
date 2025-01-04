#!/bin/bash

fp="/usr/share/hunspell/fr.dic"

cat $fp | rg '^\p{Upper}' | sort | uniq > upper.dic
grep -v '\--' upper.dic  | sponge upper.dic

char="[₀₁₂₃₄₅₆₇₈₉]"
grep "$char" upper.dic \
    | sed -r 's/[ /].*$//;s/$/\/ # po:sym/' \
    | sort | uniq \
    | sponge ../dic/chimie.dic

grep -v "$char" upper.dic \
    | sed -r 's/[ /].*$//;s/$/\/ # po:propn/' \
    | sort | uniq \
    | sponge ../dic/propn.dic

# grep 'po:nom is:mas is:inv' upper.dic > upper_nomasinv
# grep -v 'po:nom is:mas is:inv' upper.dic | sponge upper.dic
#
# grep "$char" upper_nomasinv > upper_supnum
# grep -v "$char" upper_nomasinv > upper_no_supnum
# cat upper_supnum upper.dic | sort | uniq | sponge upper.dic
# sed -r 's/[ /].*$//;s/$/\/ # po:sym/' -i upper_supnum
# mv upper_supnum ../dic/chimie.dic
# mv upper.dic ../dic/propn.dic
