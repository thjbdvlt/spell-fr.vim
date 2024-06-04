dictionnaire orthographique français au format [HunSpell](http://hunspell.github.io/) construit à partir du dictionnaire de [Grammalecte](https://grammalecte.net/), compatible avec Vim/NeoVim.

contenu du dépôt
----------------

- [vim/](./vim):  le fichier compilé (`.spl`) tel qu'il peut être utilisé pour la correction orthographique dans vim, ainsi que les fichiers `st.dic` et `st.aff` adaptés pour le produire.
- [morph/](./morph):  les fichiers `st.dic` et `st.aff` avec des informations morphologiques au format FEATS et les part-of-speech conformes aux _universal part-of-speech_.
- [dump/](./dump):  un fichier contenant tous les mots (un par ligne).
- [scripts](./scripts):  les scripts pour générer ces différents fichiers à partir des fichiers de HunSpell, notamment en enlevant les éléments qui conduisent à des erreurs lors de la compilation, ou en réorganisant et en renommant les informations morphologiques
- [words](./words):  les listes de mots.
- [affixes](./affixes):  les définitions des règles de flexions.
- [prefixes](./prefixes):  des préfixes additionnels, notamment scientifiques.
- [hunspell](./hunspell):  les fichiers sources.


différences avec le dictionnaire orthographique français par défaut de Vim
--------------------------------------------------------------------------

- ne s'occupe que d'orthographe, et pas de grammaire: une forme comme "j'arrivons" ne sera pas identifiée comme incorrecte, car elle n'est pas dysorthographique (seulement agrammaticale) et qu'il n'y a donc pas de raison qu'elle soit traitée différemment de "je partons" (que Vim ne remarquera pas comme agrammatical, puisque la fonction `spell` de Vim ne s'occupe pas de grammaire mais uniquement d'orthographe).
- par conséquent, les apostrophes et traits d'unions ne sont pas considérés dans cette version comme des `WORDCHARS` mais comme des _word boundaries_.
- écriture inclusive: auteur·rice, auteurice, auteuricex, ... (le _stemma_ des mots féminins ou masculins est la forme inclusive.)
- les mots contenant des ligatures `œ` et `æ` sont doublées de leurs versions non-ligaturées (ex. "oeuvre").
- aucun nom propre.

sources
-------

j'ai utilisé comme base le dictionnaire de Grammalecte tel qu'il est proposée dans le package debian [hunspell-fr-comprehensive](https://packages.debian.org/bookworm/hunspell-fr-comprehensive), et qui représente à mes yeux un travail formidable (et probablement gigantesque). si j'ai peu modifié la liste des mots (excepté le retranchement des noms propres, l'ajout de préfixes scientifiques comme `socio-` et de suffixes), j'ai en revanche passablement modifié la définition, les noms et la répartition des affixes, en particuliers en ce qui concerne les noms et les adjectifs. les définitions des verbes sont inchangées. les _part-of-speech_ (`po:`) ont systématiquement été remplacé par les [_universal part-of-speech tags (upos)_](https://universaldependencies.org/u/pos/). en somme, il est raisonnable de considérer ce qui se trouve dans ce dépôt comme une simple adaptation du dictionnaire Grammalecte-HunSpell pour Vim.
