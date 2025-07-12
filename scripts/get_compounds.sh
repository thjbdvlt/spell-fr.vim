#!/bin/bash

fp="/usr/share/hunspell/fr.dic"

grep '\-' $fp \
    | grep -v '\--' | grep -Pv '[.\d]'  | rg -v '^\p{Upper}' \
    | sort | uniq \
    | rg -v 'po:(npr|ponc|sign|nb)' \
    | sed -r -e 's|/\S*||' -e 's|po:nom|po:noun|g' -e 's|po:prep|po:adp|g' \
        -e 's/po:(mg|cjco)//g' -e 's|po:interj|po:intj|g' \
        -e 's/po:proind/po:pron/g' \
        -e 's|po:prodem|po:pron is:dem|g' > hunspell_compound.dic
