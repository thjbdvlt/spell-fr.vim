lang=fr
name=st
dic=${CURDIR}/$(name).dic
diraff=${CURDIR}/affixes

cp_nvim: compile
	# copie le fichier compilé (.spl) dans le dossier 'spell' de neovim
	cp ${CURDIR}/$(name).utf-8.spl \
		~/.config/nvim/spell/$(lang).utf-8.spl

compile: concat
	# compiler avec neovim, puis quitter lorsque c'est fait
	nvim -c "mkspell! $(name)" -c "q"

concat:
	# concaténer les fichiers d'affixes
	@cat $(diraff)/options.aff \
		$(diraff)/non-verbs.aff \
		$(diraff)/verbs.aff \
		> ${CURDIR}/$(name).aff
	# concaténer les dictionnaires
	@cat ${CURDIR}/words/*/*.dic  ${CURDIR}/words/*.dic | \
		sort | uniq > $(dic)
	# ajouter le nombre de mots en première ligne du fichier
	@sed -i "1s/^/$$(wc -l $(dic) | cut -d ' ' -f 1)\n/" $(dic)
