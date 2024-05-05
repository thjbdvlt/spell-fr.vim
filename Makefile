lang=fr
name=st
spl=$(name).utf-8.spl
# argument optionel: noexcept.
# à utiliser ainsi: `make noexcept=1`

cp_nvim: $(spl)
	# copie le fichier compilé (.spl) dans le dossier 'spell' de neovim
	cp $(spl) \
		~/.config/nvim/spell/$(lang).utf-8.spl

$(spl): $(name).dic $(name).aff
	# compiler avec neovim, puis quitter lorsque c'est fait
	vim -c "mkspell! $(name)" -c "q"

$(name).dic:
	# concaténer les dictionnaires.
ifdef noexcept
	@cat words/*.dic | \
		sort | uniq > $(name).dic
	make addwordnumber
else
	@cat words/*.dic exceptions/*.dic | \
		sort | uniq > $(name).dic
	make addwordnumber
endif

$(name).aff:
	# concaténer les fichiers d'affixes
	@cat affixes/options.aff \
		affixes/non-verbs.aff \
		affixes/verbs.aff \
		> $(name).aff

addwordnumber:
	# ajouter le nombre de mots en première ligne du fichier
	@sed -i "1s/^/$$(wc -l $(name).dic | cut -d ' ' -f 1)\n/" $(name).dic

clean:
	rm -f $(spl) $(name).dic $(name).aff
