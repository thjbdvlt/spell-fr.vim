#!/bin/bash

fp="/usr/share/hunspell/fr.dic"

rg '^\p{Upper}' $fp | sort | uniq > upper.dic
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
