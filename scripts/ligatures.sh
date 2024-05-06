#!/bin/bash

# ajouté les versions sans ligatures des mots qui en contiennent
# œ -> oe
# æ -> ae

filesource=$(git root)/words/words.dic
filetarget=$(git root)/words/ligatures.dic

grep "[œæ]" $filesource | sed 's/œ/oe/g;s/æ/ae/g' > $filetarget
