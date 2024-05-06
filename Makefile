lang=fr
name=st
spl=$(name).utf-8.spl

# arguments optionels: 
#
# 1. noexcept
# les 'exceptions' en questions sont les verbes "être", "avoir" et "aller" qui ont des formes tellement différentes de l'infinitif qu'elles nécessite d'enlever la totalité de l'infinitif avant d'ajouter un affixe (si on peut encore appeler ça un affixe). dans hunspell, l'option "FULLSTRIP" permet de faire ça, mais vim ne la reconnait pas: il faut donc ajouter ces formes (je suis, nous sommes, nous allons, etc.) séparément.
#
# 2. noprefix 
# (pas de préfixes scientifques: la liste se trouve dans le fichier prefixes-scientifiques.dic)
#
# 3. morph
# incompatible avec vim: décommente les annotations morphologiques et grammaticales.

cp_nvim: $(spl)
	# copie le fichier compilé (.spl) dans le dossier 'spell' de neovim
	cp $(spl) \
		~/.config/nvim/spell/$(lang).utf-8.spl

$(spl): $(name).dic $(name).aff
	# compiler avec neovim, puis quitter lorsque c'est fait
	vim -c "mkspell! $(name)" -c "q"

$(name).dic:
	@cat words/*.dic > $(name).dic
	# concaténer les dictionnaires.
ifdef noexcept
	@echo "no exceptions"
else
	@cat exceptions/*.dic >> $(name).dic
endif
ifdef noprefix
	@echo "no prefix"
else
	@cat prefixes/*.dic >> $(name).dic
endif
ifdef morph
	@./scripts/decommenter.sh $(name).dic
else
	@./scripts/enlever-commentaires.sh
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
	@./scripts/decommenter.sh $(name).aff
endif

clean:
	rm -f $(spl) $(name).dic $(name).aff
