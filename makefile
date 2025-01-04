VIMDIR = ~/.config/nvim/spell
AFF = aff/options.aff aff/non-verbs.aff aff/rep.aff aff/verbs.aff
DIC = dic/main.dic dic/deligatures.dic dic/prefixes.dic dic/compounds.dic
DIC_SUPP = dic/propn.dic dic/propn_narrafeats.dic ./dic/intj.dic
COMP = ./aff/compound.aff
CAT = sed -e '$$s/$$/\n/' -s 


.PHONY: clean install all ud test

all:
	make fr_ud.aff fr_ud.dic fr.utf-8.spl

ud:
	make fr_ud.aff fr_ud.dic

install: fr.utf-8.spl
	cp fr.utf-8.spl $(VIMDIR)/fr.utf-8.spl


# UD version
#
# inspired by Universal Dependancies POS tags
# https://universaldependencies.org/u/pos/index.html
fr_ud.aff: $(AFF) $(COMP)
	$(CAT) $(AFF) $(COMP) | sed -E 's/(\w+.*) *# *(.*$$)/\1 \2/' > fr_ud.aff
fr_ud.dic: $(DIC)
	sed -E 's/(\w+.*) *# *(.*$$)/\1 \2/' $(DIC) $(DIC_SUPP) \
		| grep -v '^ *$$' | sort | uniq > fr_ud.dic
	sed -i "1s/^/$$(wc -l fr_ud.dic | cut -d ' ' -f 1)\n/" fr_ud.dic


# VIM
fr.dic: $(DIC)
	$(CAT) $(DIC) vim/*.dic | sort | uniq \
		| sed -E 's|\s*#.*||' \
		| grep -v '^\s*$$' > fr.dic
	sed -i "1s/^/$$(wc -l fr.dic | cut -d ' ' -f 1)\n/" fr.dic

fr.aff: $(AFF)
	$(CAT) $(AFF) | sed -E 's|\s*#.*||' \
		| grep -E -v \
		'^(ICONV|IGNORE|FULLSTRIP|BREAK|WORDCHARS)\b' > fr.aff
	python3 ./scripts/add_incl.py '.' fr.aff

fr.utf-8.spl: fr.dic fr.aff
	vim -c "mkspell! fr" -c 'q'


# dump all words
fr.txt: fr.utf-8.spl
	nvim -c 'set spell spelllang=fr' -c 'spelldump!' \
		-c 'write fr.txt' -c 'qa'
	grep -v -E '(\.\w+[-·])|(-\w+[·\.])|(·\w+[-\.])' fr.txt | sponge fr.txt 


clean:
	rm -f fr.utf-8.spl fr_ud.aff fr_ud.dic fr.dic fr.aff fr.txt


test: clean fr_ud.aff fr_ud.dic
	hunspell -m -d fr_ud < tests/auteurice.txt
	hunspell -m -d fr_ud < tests/compound.txt
