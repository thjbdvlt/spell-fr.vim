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

### modifications des flags du dic, accordément aux modifications que j'écris (manuellement) dans la définitions des affixes (essentiellement pour une meilleure prise en compte de l'écriture inclusive).
# auteur·rice
sed -E -i "s;eur/(Fc|Gc|F\.Gc);eur·rice/ri;" $dic
# vif·ive, sauf·ve
sed -E -i "s|([iïu])f/F\.|\1f·ve/fv|" $dic
# aigu·ue
sed -E -i "s|gu/Fx|gu·ue/ue|" $dic
# accordeur·euse
sed -E -i "s|eur/Fs|eur·euse/rs|" $dic
# poète·sse, prophète·sse
sed -E -i "s|ète/F\.|ète·sse/ee|" $dic
# bref·ève
sed -E -i "s|ef/F\.|ef·ève/ev|" $dic
# forestier·ère
sed -E -i "s|er/F\.|er·ère/rr|" $dic
# public·que
sed -E -i "s|c/F\.|c·que/qc|" $dic
# incomplet·ète
sed -E -i "s|et/F\.|et·ète/et|" $dic
# ...en·ène
sed -E -i "s|en/F\.|en·ène/en|" $dic
# cramberry, berries
sed -E -i "s;(y|sh|man|x)/A\.;\1/GB;" $dic
# une exception avant la suite: sec·èche
sed -E -i "s,^sec/.*,sec·èche/ec," $dic
# long·ue
sed -E -i "s|g/F\.|g·ue/gu|" $dic
# les autres féminin avec le flag "F." deviennent la forme avec un "e" à la fin: enseignant·e, zurichois·e, vrai·e. important: ne pas faire avant les traitement spéciaux comme "forestier·ère".
sed -E -i "s@/F\.@·e/_e@" $dic
# les féminins qui double la dernière consonne
sed -E -i "s@([flnst])/F\+@\1·\1e/ll@" $dic
# les féminins qui ajoute -sse (prêtre·sse)
sed -E -i "s@e/F\+@e·sse/ss@" $dic
# fou·olle
sed -E -i "s@([mf]o)u/F\+@\1u·olle/lu@" $dic
# frauduleux·euse
sed -E -i "s|([eo]u)x/W\.|\1x·euse/xz|" $dic
# global·e
sed -E -i "s|al/W\.|al·e/al|" $dic
# tourtereau·elle
sed -E -i "s|eau/W\.|eau·elle/la|" $dic
# beau
sed -E -i "s|eau/Wx|eau·elle/la|" $dic
# doux·ce
sed -E -i "s|^doux/Wx|doux·ce/xc|" $dic
# roux·sse
sed -E -i "s@^(dou|fau)x/Wx@\1x·sse/xs@" $dic
# vieux·eille
sed -E -i "s|^vieux/Wx|vieux·eille/xl|" $dic
# taximan
sed -E -i "s|man/A\.|man/GB|" $dic
# flag "Gs": les féminin en ·e sur un mot en ·eur. j'enlève car c'est similaire à des suffixes déjà définis.
sed -E -i "s|Gs||" $dic
# renommer quelques suffixes pour adopter une autre terminologie.
sed -i -E 's/S\./_s/g' $dic
sed -i -E 's/X\./_x/g' $dic
sed -i -E 's/I\./LT/g' $dic

# modifie les attributs `po` (part-of-speech) dans le fichier .dic pour les faire correspondre au standard upos.
# (un seul truc qui ne change pas: po:adj)
sed -i -E -e 's/po:loc\./po:/g' \
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
    -e 's/po:titr/po:pro/g' \
    -e 's/po:sign//g' \
    $dic

# modifie les attribut `po` dans le fichier .aff, comme il s'agit essentiellement d'indications de temps verbaux et de personnes, je déplace en `is` (inflectionnal suffix), car il me semble que cela ne relève pas du part-of-speech.
sed -i -E -e 's/po:/is:/g' $aff

# une fois cela fait, je déplace le fichier .dic vers ../words/words.dic, car la compilation se fait à partir des fichiers qui se trouve dans ce dossier. le fichier .aff doit en revanche être édité manuellement et partiellement réécrit. 
cp $dic ${root}/words/words.dic
