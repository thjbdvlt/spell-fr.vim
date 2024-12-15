VIMDIR = ~/.config/nvim/spell
AFF = aff/options.aff aff/non-verbs.aff aff/rep.aff aff/verbs.aff
DIC = dic/main.dic dic/deligatures.dic dic/prefixes.dic
COMP = ./aff/compound.aff
CAT = sed -e '$$s/$$/\n/' -s 


.PHONY: clean install all ud test

all:
	make fr_ud.aff fr_ud.dic fr.utf-8.spl

ud:
	make fr_ud.aff fr_ud.dic

install: fr.utf-8.spl
	cp fr.utf-8.spl $(VIMDIR)/fr.utf-8.spl


# options and affixes definitions
#
# inspired by Universal Dependancies POS tags
# https://universaldependencies.org/u/pos/index.html
#
# this only uncomment (to make morph. features readable).
fr_ud.aff: $(AFF) $(COMP)
	$(CAT) $(AFF) $(COMP) | sed -E 's/(\w+.*) *# *(.*$$)/\1 \2/' > fr_ud.aff

# dictionary file for the UD version of the spell files
#
# uncomment and add the correct number of words at the top 
# of the file.
fr_ud.dic: $(DIC)
	sed -E 's/(\w+.*) *# *(.*$$)/\1 \2/' $(DIC) \
		| grep -v '^ *$$' | sort | uniq > fr_ud.dic
	sed -i "1s/^/$$(wc -l fr_ud.dic | cut -d ' ' -f 1)\n/" fr_ud.dic


# dictionary file for vim
#
# add exceptions, remove all comments and add the number 
# of words.
fr.dic: $(DIC)
	$(CAT) $(DIC) vim/*.dic | sort | uniq \
		| sed -E 's|\s*#.*||' \
		| grep -v '^\s*$$' > fr.dic
	sed -i "1s/^/$$(wc -l fr.dic | cut -d ' ' -f 1)\n/" fr.dic

# affix file for vim
fr.aff: $(AFF)
	$(CAT) $(AFF) | sed -E 's|\s*#.*||' \
		| grep -E -v 'ICONV|IGNORE|FULLSTRIP' > fr.aff
	python3 ./scripts/add_incl.py . fr.aff

# the spell file for (neo)vim
#
# compile with the vim `:mkspell` command, then exit.
fr.utf-8.spl: fr.dic fr.aff
	vim -c "mkspell! fr" -c 'q'

# dump the spell file, to get a list of all possible words.
fr.txt: fr.utf-8.spl
	nvim -c 'set spell spellang fr' -c 'spelldump!' -c 'write fr.txt' -c 'qa'


clean:
	rm -f fr.utf-8.spl fr_ud.aff fr_ud.dic fr.dic fr.aff fr.txt

test: fr_ud.aff fr_ud.dic
	hunspell -m -d fr_ud < tests/auteurice.txt
	hunspell -m -d fr_ud < tests/compound.txt
