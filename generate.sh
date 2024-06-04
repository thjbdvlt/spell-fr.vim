#!/bin/bash

# génère les différents fichiers:
# - le fichier compilé `.spl` pour vim;
# - les fichiers avec les annotations en FEATS;
# - un fichier avec tous les mots du lexique (un par ligne).

cd $(git rev-parse --show-toplevel)

# concaténation des affixes: st.aff
cat affixes/options.aff \
    affixes/non-verbs.aff \
    affixes/verbs.aff > st.aff

# créer le fichier ligatures.dic s'il n'existe pas
if ! [ -f ./words/ligatures.dic ];then
    ./scripts/ligatures.sh
fi

# concaténation des mots: st.dic
cat words/*.dic > st.dic
cat prefixes/*.dic >> st.dic
sort < st.dic | uniq | sponge st.dic 

# placer des copies dans les dossiers vim et morph
for directory in vim morph; do
    # (crée les dossiers pour les fichiers, 
    # s'ils n'existent pas.)
    if ! [ -d ${directory} ];then
        mkdir ${directory}
    fi
    cp st.dic st.aff ${directory}/
done

_sortuniq() {
    sort < $1 | uniq | sponge $1
}

# création des fichiers pour l'analyse morphologique
cd morph
../scripts/decommenter.sh st.dic
../scripts/decommenter.sh st.aff
_sortuniq st.dic
../scripts/header-number.sh st.dic

# création des fichiers pour vim
cd ../vim
../scripts/enlever-commentaires.sh st.dic
../scripts/enlever-commentaires.sh st.aff
_sortuniq st.dic
../scripts/header-number.sh st.dic
vim -c "mkspell! st" -c "q"
cp st.utf-8.spl ~/.config/nvim/spell/fr.utf-8.spl

# retourner au toplevel
cd ..

# dump un fichier avec tous les mots
if ! [ -d dump ];then mkdir dump; fi
unmunch st.dic st.aff \
    | sed -E 's;/.*;;g' \
    | sort | uniq > dump/all_words.txt

# suppression des fichiers intermédiaires
rm st.dic st.aff
