lang=fr
name=st
spl=$(name).utf-8.spl
spelldir=~/.config/nvim/spell

# options: `make [rules] [morph=1] [noprefix=1]`
#
# `morph`
# incompatible avec vim: décommente les annotations morphologiques et grammaticales. comme cette option est incompatible avec vim, il faut l'utiliser en précisant une commande: `make concat morph=1`.
# enlève également les 'exceptions' que sont les verbes "être", "avoir" et "aller", lesquels verbes ont des formes tellement différentes de l'infinitif qu'elles nécessite d'enlever la totalité de l'infinitif avant d'ajouter un affixe (si on peut encore appeler ça un affixe). dans hunspell, l'option "FULLSTRIP" permet de faire ça, mais vim ne la reconnait pas: il faut donc ajouter ces formes (je suis, nous sommes, nous allons, etc.) séparément, ce que fait le Makefile sans paramètre (destiné à Vim).
#
# `noprefix` 
# (pas de préfixes scientifques: la liste se trouve dans le fichier prefixes-scientifiques.dic).

all:
	# copie le fichier compilé (.spl) dans le dossier 'spell' de neovim
ifdef morph
	# avec l'option morph, pas de compilation: uniquement la concaténation.
	make concat
else
	# sans l'option morph, compiler le fichier et ensuite le placer dans le dossier 'spell' de neovim.
	make cp_file
endif

cp_file: $(spl)
	# copier le fichier compiler dans le dossier de spell.
	cp $(spl) $(spelldir)/$(lang).utf-8.spl

concat: $(name).dic $(name).aff
	# concaténation des fichiers *.dic et *.aff

$(spl): $(name).dic $(name).aff
	# compilation avec vim
	vim -c "mkspell! $(name)" -c "q"

$(name).dic:
	# concaténer les dictionnaires.
	# c'est ici que s'applique la plupart des options, qui servent à inclure ou exclure certains types d'objets lexicaux, par exemple les préfixes.
	@cat words/*.dic > $(name).dic
ifdef noprefix
else
	@cat prefixes/*.dic >> $(name).dic
endif
ifdef morph
	@./scripts/decommenter.sh $(name).dic
else
	# enlever les exceptions
	@cat exceptions/*.dic >> $(name).dic
	@./scripts/enlever-commentaires.sh $(name).dic
endif
	sort < $(name).dic | uniq | sponge $(name).dic 
	./scripts/header-number.sh $(name).dic

$(name).aff:
	# concaténer les fichiers d'affixes
	@cat affixes/options.aff \
		affixes/non-verbs.aff \
		affixes/verbs.aff \
		> $(name).aff
ifdef morph
	# dé-commenter les informations morphologiques et grammaticales: part-of-speech notamment. comme certaines lignes doivent rester des commentaires, j'utilise pour çâ un script spécial (même s'il est extrêmement simpe). (ce qui évite de devoir escape les caractères.)
	@./scripts/decommenter.sh $(name).aff
else
	# enlever les commentaires pour accélerer la lecture du fichier pendant la compilation.
	@./scripts/enlever-commentaires.sh $(name).aff
endif

dump:
	unmunch $(name).dic $(name).aff \
		| sed -E 's;/.*;;g' \
		| sort | uniq > dump/all_words.txt

clean:
	rm -f $(spl) $(name).dic $(name).aff
