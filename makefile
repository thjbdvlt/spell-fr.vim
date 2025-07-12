VIMDIR  := $(HOME)/.vim/spell
NVIMDIR := $(HOME)/.config/nvim/spell
HUNDIR  := /usr/share/hunspell

name    := fr_ud

cat     := sed -e '$$s/$$/\n/' -s 

dic     := dic/main.dic \
		   dic/prefixes.dic \
		   dic/compounds.dic \
		   dic/num_compounds.dic \
		   dic/hunspell_compound.dic
dic_out := dic/intj.dic \
		   dic/common_mistakes.dic \
		   dic/allographe.dic \
		   dic/foreign.dic
dic_pn  := dic/propn.dic \
		   dic/propn_narrafeats.dic \
		   dic/propn_init.dic 
aff     := aff/options.aff \
		   aff/non-verbs.aff \
		   aff/rep.aff \
		   aff/verbs.aff
comp    := aff/compound.aff

.PHONY: all install-vim install-hunspell clean test

all: ud vim

install-vim: fr.utf-8.spl
	test -d $(VIMDIR) && cp fr.utf-8.spl $(VIMDIR)/fr.utf-8.spl
	test -d $(NVIMDIR) && cp fr.utf-8.spl $(NVIMDIR)/fr.utf-8.spl

install-hunspell:  $(name).aff $(name).dic
	cp $(name).aff $(name).dic $(HUNDIR)

# Version with morphological features and UD part-of-speeches
$(name).aff: $(aff) $(comp)
	for i in $^; do cat $$i; echo; done | \
		sed -E 's/(\w+.*) *# *(.*$$)/\1 \2/' > $@

$(name).dic: $(dic) $(dic_out)
	sed -E 's/(\w+.*) *# *(.*$$)/\1 \2/' $^ \
		| grep -v '^ *$$' | sort | uniq > $@
	sed "1s/^/$$(wc -l < $@)\n/" $@ | sponge $@

# Vim-compatible version
fr.dic: $(dic) $(DIC_PROPN) vim/*.dic
	cat $^ | \
		sort | uniq | sed -E 's|\s*#.*||' | grep -v '^\s*$$' > $@
	sed "1s/^/$$(wc -l < $@)\n/" $@ | sponge $@

fr.aff: $(aff)
	for i in $^; do cat $$i; echo; done | \
		sed -E 's|\s*#.*||' \
		| grep -E -v \
		'^(ICONV|IGNORE|FULLSTRIP|BREAK|WORDCHARS)\b' > $@
	python3 ./scripts/add_incl.py '.' $@

fr.utf-8.spl: fr.dic fr.aff
	vim -c "mkspell! fr" -c 'q'


# Dump all words in a text file
fr.txt: $(install)
	nvim -c 'set spell spelllang=fr' -c 'spelldump!' \
		-c 'write fr.txt' -c 'qa'
	grep -v '[-.œæ]' $@ | sponge $@


clean:
	rm -f fr.utf-8.spl $(name).aff $(name).dic fr.dic fr.aff fr.txt


test: clean $(name).aff $(name).dic
	hunspell -m -d $(name) < tests/auteurice.txt
	hunspell -m -d $(name) < tests/compound.txt
	echo 'mes sens' | hunspell -m -d $(name) 
	echo 'fin' | hunspell -m -d $(name) 
	hunspell -m -d $(name) < tests/tenses.txt
