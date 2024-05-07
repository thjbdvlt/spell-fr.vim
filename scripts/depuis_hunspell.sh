#!/bin/bash

# récupérer et modifier les dictionnaires de hunspell (ceux, en fait, de grammalecte), ils sont très complets (ça me semble être un travail assez formidable), et moyennant quelques modifications, ils sont tout à fait utilisables pour vim.

suffname=_st

root=$(git rev-parse --show-toplevel)
copydir=${root}/hunspell

# créer le dossier s'il n'existe pas, et copier les fichiers depuis hunspell s'ils n'existent pas déjà. et faire une seconde copie qui est celle que je modifie (comme ça je garde toujours une copie des fichiers non-modifié de hunspell).
if ! [ -d ${copydir} ];then mkdir -p "$d"; fi
for i in dic aff;do
    copyfp=${copydir}/fr.${i}
    fp=${copydir}/fr${suffname}.${i}
    if ! [ -f "$fp" ];then
        cp /usr/share/hunspell/fr.${i} ${copyfp}
    fi
    cp $copyfp $fp
done

# les deux fichiers que je vais modifier.
dic=${copydir}/fr${suffname}.dic
aff=${copydir}/fr${suffname}.aff

### la première partie du script fait un tri dans les lignes en utilisant grep/rg --invert.

# enlever les mots avec des tirets (car je décide que les tirets coupent les mots), et les mots qui commencent avec des majuscules (les noms propres). enlever aussi les lignes avec "||", qui correspond à KEEPCASE donc plutôt des non-mots (ou noms propres). idem pour "--", c'est NOSUGGEST. c'est des nombres romains et des préfixes, et d'autres trucs qui ne me semble pas vraiment utiles. j'enlève aussi les mots qui contiennent des nombres: les nombres ne sont pas des mots et ça me semble un peu arbitraire d'avoir des marques ou des choses comme ça: à ajouter par les utilisateur·rices.
egrep -v "^[^/]+-" $dic | \
    rg -v "^[\p{Uppercase}]" | \
    rg -v "\|\|" | \
    rg -v "\-\-" | \
    rg -v '^[\w]*\d' | \
    rg -v 'po:npr' | \
    sponge $dic

# enlever certaines lignes entières de features non-supportées par vim. les apostrophes et tirets de la liste des caractères qui font partie des mots.
rg -v "^TRY " $aff | \
    rg -v "^WORDCHARS " | \
    rg -v "^ICONV " | \
    rg -v "^OCONV " | \
    rg -v "^KEY " | \
    rg -v "^BREAK " | \
    rg -v "^REP " | \
    rg -v "^MAP " | \
    rg -v "^KEEPCASE " | \
    rg -v "^NOSUGGEST " | \
    sponge $aff

### ensuite, un tri dans les flags.
# enlever les () qui d'une part pose problème, mais en plus sont de trop avec les modifications que je fais (ça discard des mots essentiels comme "je" ou "nous").
sed -E -i "s/\(\)//g" $dic

# j'enlève tout ce qui concerne les préfixes d'apostrophes: tout comme les tirets, les apostrophes sont ici considérées comme des limites entre des mots (des 'word boundaries' et non des 'word chars').
rg -v "^PFX (\w+'|Q*|Qj)" $aff | sponge $aff

# j'enlève les mots qui ont des apostrophes dans le mot, car je coupe les mots sur les apostrophes. et j'enlève dans le .dic les suffixes avec des apostrophes, et ceux qui concernent les préfixes+apostrophes.
rg -v "^[^/]+'.*$" $dic | sponge $dic
for i in $dic $aff; do
    sed -i -E "s/(\w'|Qj|Q\*)//g" $i
done

# enlever les espaces en fin de ligne, et les espaces multiples successifs.
for i in $dic $aff; do
    sed -E -i 's/ +$//g' $i
    sed -E -i 's/  +/ /g' $i
done

# je n'ai pas besoin d'avoir de différences entre S. et S= vu que pas de préfixes. tout va dans "S."
grep -v "^SFX S=" $aff | sponge $aff
sed -E -i "s|S=|S.|g" $dic

# commenter les informations morphologiques et grammaticales qui produisent des erreurs dans la compilation avec vim et peut discard (je crois) des lignes. comme il n'y a aucun commentaire dans le fichiers .dic et que les seuls commentaires dans le fichiers .aff sont au tout début (et en début de ligne), il n'est pas difficile de les enlever par la suite.
sed -E -i 's/ (.*$)/  # \1/' $dic
sed -E -i 's/^(SFX \S+ \S+ \S+ \S+) (.*$)/\1 # \2/' $aff

# s'il manque le '/' et qu'ensuite il y a un commentaire, alors la ligne est discard. il faut donc les ajouter.
sed -E -i 's|^(\w+) |\1/ |' $dic

## todo: ici, faire un seul script, plutôt. parce qu'ils sont toujours utilisés ensemble et dans le même ordre: pas de sens à ce qu'ils soint séparés.
s=$(git rev-parse --show-toplevel)/scripts
# utiliser le script qui modifie les affixes dans le fichier .dic (essentiellement pour les suffixes féminin/masculin et l'écriture inclusive).
${s}/remplacer-sfx.sh
# utiliser les deux scripts qui remplacent les part-of-speech (où les autres informations qui sont placées dans l'attributs `po:`) par des POS tags standardisés (upos).
${s}/vers-upos.sh $dic
${s}/po-to-is-aff.sh $aff
