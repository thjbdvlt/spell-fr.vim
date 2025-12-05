# spell-fr.vim - correction orthographique du français contemporain pour Vim
#
# Définition des dossiers où doivent être installés les fichiers.
# (Les fichiers ne sont copiés que dans les dossiers existants.)
#
# La variable $(VIMDIR) est aussi ajouter, pour une utiilsation plus facile
# en ligne de commande: `make VIMDIR=~/.config/vim/spell`
# (Idem pour HUNDIRS et HUNDIR.)
VIMDIRS := $(HOME)/.vim/spell \
					 $(HOME)/.config/nvim/spell \
					 $(VIMDIR)
HUNDIRS := /usr/share/hunspell \
					 $(HUNDIR)

# Définition du suffixe utilisé pour Hunspell.
# Par exemple "fr" pour "fr_fr" ou "ch" pour "fr_ch".
name := fr_ud

spl              := fr.utf-8.spl # le nom du fichier généré pour vim

existing_vimdirs := $(wildcard $(VIMDIRS)) # ne conserver que les dossires existants
vim_targets      := $(existing_vimdirs:=/$(spl)) # construire les cibles

dic     := $(wildcard dic/*.dic)

aff     := aff/options.aff \
		       aff/non-verbs.aff \
		       aff/rep.aff \
		       aff/verbs.aff
comp    := aff/compound.aff

.PHONY: all install-vim install-hunspell clean test

all: $(vim_targets)

%/$(spl): $(spl)
	cp $< $@

install-hunspell: $(name).aff $(name).dic
	$(foreach d,$(wildcard $(HUNDIRS)),cp $^ $(d))

# Version with morphological features and UD part-of-speeches
$(name).aff: $(aff) $(comp)
	for i in $^; do cat $$i; echo; done | \
		sed -E 's/(\w+.*) *# *(.*$$)/\1 \2/' > $@

$(name).dic: dic/*.dic dic/outof/*.dic dic/propn/*.dic
	sed -E 's/(\w+.*) *# *(.*$$)/\1 \2/' $^ \
		| grep -v '^ *$$' | sort | uniq > $@
	sed "1s/^/$$(wc -l < $@)\n/" $@ | sponge $@

# Vim-compatible version
fr.dic: dic/*.dic dic/vim/*.dic
	cat $^ | \
		sort | uniq | sed -E 's|\s*#.*||' | grep -v '^\s*$$' > $@
	sed "1s/^/$$(wc -l < $@)\n/" $@ | sponge $@

fr.aff: $(aff) aff/vim/compounds.aff
	for i in $^; do cat $$i; echo; done | \
		sed -E 's|\s*#.*||' \
		| grep -E -v \
		'^(ICONV|IGNORE|FULLSTRIP|BREAK|WORDCHARS)\b' > $@
	python3 ./scripts/add_incl.py '.' $@

$(spl): fr.dic fr.aff
	vim -c "mkspell! fr" -c 'q'


# Dump all words in a text file
fr.txt: $(install)
	nvim -c 'set spell spelllang=fr' -c 'spelldump!' \
		-c 'write fr.txt' -c 'qa'
	grep -v '[-.œæ]' $@ | sponge $@


clean:
	rm -f $(spl) $(name).aff $(name).dic fr.dic fr.aff fr.txt


test: clean $(name).aff $(name).dic
	hunspell -m -d $(name) < tests/auteurice.txt
	hunspell -m -d $(name) < tests/compound.txt
	echo 'mes sens' | hunspell -m -d $(name) 
	echo 'fin' | hunspell -m -d $(name) 
	hunspell -m -d $(name) < tests/tenses.txt
