VIMDIR = ~/.config/nvim/spell

AFF = aff/options.aff aff/non-verbs.aff aff/rep.aff aff/verbs.aff
COMP = aff/compound.aff
DIC = dic/main.dic dic/prefixes.dic dic/compounds.dic dic/num_compounds.dic dic/hunspell_compound.dic
DIC_SUPP = dic/intj.dic dic/common_mistakes.dic dic/allographe.dic dic/foreign.dic
DIC_PROPN = dic/propn.dic dic/propn_narrafeats.dic dic/propn_init.dic 
CAT = sed -e '$$s/$$/\n/' -s 

.PHONY: ud vim all install clean test install_postgresql

all: ud vim

ud: fr_ud.aff fr_ud.dic

vim: fr.utf-8.spl

install: fr.utf-8.spl
	cp fr.utf-8.spl $(VIMDIR)/fr.utf-8.spl

# version for morphological analysis
#
# it uses Universal Dependancies POS tags as values for `po:` feature
# https://universaldependencies.org/u/pos/index.html
fr_ud.aff: $(AFF) $(COMP)
	for i in $^; do cat $$i; echo; done | \
		sed -E 's/(\w+.*) *# *(.*$$)/\1 \2/' > $@

fr_ud.dic: $(DIC) $(DIC_SUPP)
	sed -E 's/(\w+.*) *# *(.*$$)/\1 \2/' $^ \
		| grep -v '^ *$$' | sort | uniq > $@
	sed "1s/^/$$(wc -l < $@)\n/" $@ | sponge $@


# VIM version, no morphological features (not supported by vim spell engine), but with PROPN (title case)
fr.dic: $(DIC) $(DIC_PROPN) vim/*.dic
	cat $^ | \
		sort | uniq | sed -E 's|\s*#.*||' | grep -v '^\s*$$' > $@
	sed "1s/^/$$(wc -l < $@)\n/" $@ | sponge $@

fr.aff: $(AFF)
	for i in $^; do cat $$i; echo; done | \
		sed -E 's|\s*#.*||' \
		| grep -E -v \
		'^(ICONV|IGNORE|FULLSTRIP|BREAK|WORDCHARS)\b' > $@
	python3 ./scripts/add_incl.py '.' $@

fr.utf-8.spl: fr.dic fr.aff
	vim -c "mkspell! fr" -c 'q'


# dump all words
fr.txt: $(install)
	nvim -c 'set spell spelllang=fr' -c 'spelldump!' \
		-c 'write fr.txt' -c 'qa'
	grep -v '[-.œæ]' $@ | sponge $@


clean:
	rm -f fr.utf-8.spl fr_ud.aff fr_ud.dic fr.dic fr.aff fr.txt


test: clean fr_ud.aff fr_ud.dic
	hunspell -m -d fr_ud < tests/auteurice.txt
	hunspell -m -d fr_ud < tests/compound.txt
