#!/bin/bash

# modifie le fichier .dic provenant de hunspell et l'ajuste aux affixes que j'ai définis pour pouvoir prendre en compte diverses formes d'écriture inclusive.

f=$(git root)/words/words.dic

cp $(git root)/hunspell/fr.dic $f

# plutôt qu'un seul affixe pour toutes les formes du féminin, je fais un affixe pour chaque forme

# auteur·rice
sed -E -i "s;eur/(Fc|Gc|F\.Gc);eur·rice/ri;" $f

# vif·ive, sauf·ve
sed -E -i "s|([iïu])f/F\.|\1f·ve/fv|" $f

# aigu·ue
sed -E -i "s|gu/Fx|gu·ue/ue|" $f

# accordeur·euse
sed -E -i "s|eur/Fs|eur·euse/rs|" $f

# poète·sse, prophète·sse
sed -E -i "s|ète/F\.|ète·sse/ee|" $f

# bref·ève
sed -E -i "s|ef/F\.|ef·ève/ev|" $f

# forestier·ère
sed -E -i "s|er/F\.|er·ère/rr|" $f

# public·que
sed -E -i "s|c/F\.|c·que/qc|" $f

# incomplet·ète
sed -E -i "s|et/F\.|et·ète/et|" $f

# ...en·ène
sed -E -i "s|en/F\.|en·ène/en|" $f

# cramberry, berries
sed -E -i "s;(y|sh|man|x)/A\.;\1/GB;" $f

# une exception avant la suite: sec·èche
sed -E -i "s,^sec/.*,sec·èche/ec," $f

# long·ue
sed -E -i "s|g/F\.|g·ue/gu|" $f

# les autres féminin avec le flag "F." deviennent la forme avec un "e" à la fin: enseignant·e, zurichois·e, vrai·e. important: ne pas faire avant les traitement spéciaux comme "forestier·ère".
sed -E -i "s@/F\.@·e/_e@" $f

# les féminins qui double la dernière consonne
sed -E -i "s@([flnst])/F\+@\1·\1e/ll@" $f

# les féminins qui ajoute -sse (prêtre·sse)
sed -E -i "s@e/F\+@e·sse/ss@" $f

# fou·olle
sed -E -i "s@([mf]o)u/F\+@\1u·olle/lu@" $f

# frauduleux·euse
sed -E -i "s|([eo]u)x/W\.|\1x·euse/xz|" $f

# global·e
sed -E -i "s|al/W\.|al·e/al|" $f

# tourtereau·elle
sed -E -i "s|eau/W\.|eau·elle/la|" $f
# beau
sed -E -i "s|eau/Wx|eau·elle/la|" $f

# doux·ce
sed -E -i "s|^doux/Wx|doux·ce/xc|" $f

# roux·sse
sed -E -i "s@^(dou|fau)x/Wx@\1x·sse/xs@" $f

# vieux·eille
sed -E -i "s|^vieux/Wx|vieux·eille/xl|" $f

# taximan
sed -E -i "s|man/A\.|man/GB|" $f

# flag "Gs": les féminin en ·e sur un mot en ·eur. j'enlève car c'est similaire à des suffixes déjà définis.
sed -E -i "s|Gs||" $f

# renommer quelques suffixes pour adopter une autre terminologie.
sed -i -E 's/S\./_s/g' $f
sed -i -E 's/X\./_x/g' $f
sed -i -E 's/I\./LT/g' $f
