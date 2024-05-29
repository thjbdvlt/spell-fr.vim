dictionnaire orthographique français au format [HunSpell](http://hunspell.github.io/) construit à partir du dictionnaire de [Grammalecte](https://grammalecte.net/), au format HunSpell, compatible avec Vim/NeoVim.

contenu du dépôt
----------------

- la définitions des affixes dans les fichiers `.aff`.
- les listes de mots dans les fichiers `.dic`.
- un Makefile pour les assembler à l'aide de Vim (`vim -e "mkspell ..."`).
- des scripts pour les produire (à partir des fichiers de HunSpell) et les modifier (`sed`, `grep -v`, ...).

différences avec le dictionnaire orthographique français par défaut de Vim
--------------------------------------------------------------------------

- ne s'occupe que d'orthographe, et pas de grammaire: une forme comme "j'arrivons" ne sera pas identifiée comme incorrecte, car elle n'est pas dysorthographique -- seulement agrammaticale -- et qu'il n'y a donc pas de raison qu'elle soit traitée différemment de "je partons" (que Vim ne remarquera pas comme agrammatical, puisque la fonction `spell` de Vim ne s'occupe pas de grammaire mais uniquement d'orthographe).
- par conséquent, les apostrophes et traits d'unions ne sont pas considérés dans cette version comme des `WORDCHARS` mais comme des _word boundaries_.
- écriture inclusive: auteur·rice, auteurice. (le _stemma_ des mots féminins ou masculins est la forme inclusive.)
- les mots contenant des ligatures `œ` et `æ` sont doublées de leurs versions non-ligaturées (ex. "oeuvre").
- aucun nom propre.

usage
-----

quoi qu'il s'agisse avant tout d'un projet destiné à faire de la correction orthographique, la définition d'un lexique et de règles dérivationnelles pour chacun de ces éléments en fait un outil utile à l'analyse textuelle, en particulier pour l'analyse morphologique (flexionnelle) et la lemmatisation.

pour l'utiliser comme correcteur orthographique dans VIM:

```shell
make
```

pour compiler les fichiers et les utiliser avec HunSpell pour l'analyse:

```shell
make morph=1
```

sources
-------

j'ai utilisé comme base le dictionnaire de Grammalecte tel qu'il est proposée dans le package debian [hunspell-fr-comprehensive](https://packages.debian.org/bookworm/hunspell-fr-comprehensive), et qui représente à mes yeux un travail formidable (et probablement gigantesque). si j'ai peu modifié la liste des mots (excepté le retranchement des noms propres, l'ajout de préfixes scientifiques comme `socio-` et de suffixes), j'ai en revanche passablement modifié la définition, les noms et la répartition des affixes, en particuliers en ce qui concerne les noms et les adjectifs. les définitions des verbes sont inchangées. les _part-of-speech_ (`po:`) ont systématiquement été remplacé par les [_universal part-of-speech tags (upos)_](https://universaldependencies.org/u/pos/). en somme, il est raisonnable de considérer ce qui se trouve dans ce dépôt comme une simple adaptation du dictionnaire Grammalecte-HunSpell pour Vim.
