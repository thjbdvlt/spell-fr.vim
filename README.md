dictionnaire orthographique français pour Vim construit à partir du dictionnaire de [Grammalecte](https://grammalecte.net/), au format HunSpell.

### contenu du dépôt

- la définitions des affixes dans les fichiers `.aff`.
- les listes de mots dans les fichiers `.dic`.
- un Makefile pour les assembler à l'aide de Vim (`vim -e "mkspell ..."`).
- des scripts pour les produire (à partir des fichiers de HunSpell) et les modifier (`sed`, `grep -v`, ...).

### différences avec le dictionnaire orthographique français par défaut de Vim

- ne s'occupe que d'orthographe, et pas de grammaire: une forme comme "j'arrivons" ne sera pas soulignée comme incorrecte, car elle n'est pas dysorthographique -- seulement agrammaticale -- et qu'il n'y a donc pas de raison qu'elle soit traitée différemment de "je partons" (que Vim ne remarquera pas comme agrammatical, puisque la fonction `spell` de Vim ne s'occupe pas de grammaire mais uniquement d'orthographe).
- par conséquent, les apostrophes et traits d'unions ne sont pas considérés dans cette version comme des `WORDCHARS` mais comme des _word boundaries_.
- écriture inclusive: auteur, autrice, auteur-rice, auteurice.
- les mots contenant des ligatures `œ` et `æ` sont doublées de leurs versions non-ligaturées (ex. "oeuvre").
- aucun nom propre.

### sources

j'ai utilisé comme base le dictionnaire de Grammalecte tel qu'il est proposée dans le package debian [hunspell-fr-comprehensive](https://packages.debian.org/bookworm/hunspell-fr-comprehensive), et qui représente à mes yeux un travail formidable (et probablement gigantesque). si j'ai peu modifié la liste des mots (excepté le retranchement des noms propres, l'ajout de préfixes scientifiques comme `socio-` et de suffixes), j'ai en revanche passablement modifié la définition, les noms et la répartition des affixes, en particuliers en ce qui concerne les noms et les adjectifs. les définitions des verbes sont inchangées. aussi, il est raisonnable de considérer ce qui se trouve dans ce dépôt comme une simple adaptation du dictionnaire Grammalecte-HunSpell pour Vim.
