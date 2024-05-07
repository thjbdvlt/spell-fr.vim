#!/bin/bash

# remplace les po:loc.detind, po:v1__e_, po:cjco, etc. par le tag correspondant en UPOS, universal part-of-speech tags.

file="$1"

if ! [ -f "$file" ];then echo "no file, exit."; exit 1; fi

# (un seul truc qui ne change pas: po:adj)
sed -E -e 's/po:loc\./po:/g' \
    -e 's/po:nom\S*/po:noun/g' \
    -e 's/po:ponc/po:punct/g' \
    -e 's/po:pro\S*/po:pron/g' \
    -e 's/po:(sg|epi|mg)//g' \
    -e 's/po:nb/po:num/g' \
    -e 's/po:(cjsub|cj)\S*/po:sconj/g' \
    -e 's/po:(cjco|cj)\S*/po:cconj/g' \
    -e 's/po:det\S*/po:det/g' \
    -e 's/po:adv\S*/po:adv/g' \
    -e 's/po:v\S*/po:verb/g' \
    -e 's/po:inf\S*//g' \
    -e 's/po:interj/po:intj/g' \
    -e 's/po:patr\S*/po:part/g' \
    -e 's/po:pfx\S*/po:part/g' \
    -e 's/po:preverb/po:adp/g' \
    -e 's/po:(\d\S*)/is:\1/g' \
    "$file"
