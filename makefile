VIMDIR = ~/.config/nvim/spell
AFF = aff/options.aff aff/non-verbs.aff aff/rep.aff aff/verbs.aff
DIC = dic/main.dic dic/deligatures.dic dic/prefixes.dic dic/compounds.dic
DIC_SUPP = dic/intj.dic dic/softwares.dic dic/common_mistakes.dic dic/allographe.dic
DIC_PROPN = dic/propn.dic dic/propn_narrafeats.dic dic/propn_init.dic 
DIC_COMPOUND =  dic/hunspell_compound.dic dic/num_compounds.dic
COMP = ./aff/compound.aff
CAT = sed -e '$$s/$$/\n/' -s 


.PHONY: ud vim all install clean test

all:
	make fr_ud.aff fr_ud.dic fr.utf-8.spl

ud:
	make fr_ud.aff fr_ud.dic

vim: fr.utf-8.spl

install: fr.utf-8.spl
	cp fr.utf-8.spl $(VIMDIR)/fr.utf-8.spl


# UD version
#
# inspired by Universal Dependancies POS tags
# https://universaldependencies.org/u/pos/index.html
fr_ud.aff: $(AFF) $(COMP)
	$(CAT) $(AFF) $(COMP) | sed -E 's/(\w+.*) *# *(.*$$)/\1 \2/' > $@
fr_ud.dic: $(DIC) $(DIC_SUPP)
	sed -E 's/(\w+.*) *# *(.*$$)/\1 \2/' $(DIC) $(DIC_SUPP) \
		| grep -v '^ *$$' | sort | uniq > $@
	sed -i "1s/^/$$(wc -l fr_ud.dic | cut -d ' ' -f 1)\n/" $@


# VIM
fr.dic: $(DIC)
	$(CAT) $(DIC) vim/*.dic | sort | uniq \
		| sed -E 's|\s*#.*||' \
		| grep -v '^\s*$$' > $@
	sed -i "1s/^/$$(wc -l fr.dic | cut -d ' ' -f 1)\n/" $@

fr.aff: $(AFF)
	$(CAT) $(AFF) | sed -E 's|\s*#.*||' \
		| grep -E -v \
		'^(ICONV|IGNORE|FULLSTRIP|BREAK|WORDCHARS)\b' > $@
	python3 ./scripts/add_incl.py '.' $@

fr.utf-8.spl: fr.dic fr.aff
	vim -c "mkspell! fr" -c 'q'


# dump all words
fr.txt: fr.utf-8.spl
	nvim -c 'set spell spelllang=fr' -c 'spelldump!' \
		-c 'write fr.txt' -c 'qa'
	grep -v -E '(\.\w+[-·])|(-\w+[·\.])|(·\w+[-\.])' $@ | sponge $@


clean:
	rm -f fr.utf-8.spl fr_ud.aff fr_ud.dic fr.dic fr.aff fr.txt


test: clean fr_ud.aff fr_ud.dic
	hunspell -m -d fr_ud < tests/auteurice.txt
	hunspell -m -d fr_ud < tests/compound.txt
