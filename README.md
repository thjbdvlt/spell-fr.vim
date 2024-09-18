Dictionnaire orthographique français au format [HunSpell](http://hunspell.github.io/) construit à partir du dictionnaire de [Grammalecte](https://grammalecte.net/), compatible avec [Vim](https://www.vim.org/)/[NeoVim](https://neovim.io/)).

contenu du dépôt
----------------

Dans le dossier [vim/](./vim) se trouvent le fichier compilé (`.spl`) tel qu'il peut être utilisé pour la correction orthographique dans vim, ainsi que les fichiers `st.dic` et `st.aff` adaptés pour le produire. Le dossier [morph/](./morph) contient, lui, les fichiers `st.dic` et `st.aff` avec les informations morphologiques, les part-of-speech modifiés pour correspondre aux _universal part-of-speech_: on peut les utiliser pour faire de l'analyse morphologique (le fichier [feats/lookup.tsv](feats/lookup.tsv) permet de récupérer, sans trop de perte, les [FEATS](https://universaldependencies.org/u/feat/index.html) correspondant à chaque flag morphologique). On trouvera également un fichier avec la liste de tous les mots possibles (un par ligne) dans [dump/](./dump). Les autres dossiers contiennent les données et scripts utilisées pour produire ces fichiers.

différences avec le dictionnaire orthographique français par défaut de Vim
--------------------------------------------------------------------------

- Ne s'occupe que d'orthographe, et pas de grammaire: une forme comme "j'arrivons" ne sera pas identifiée comme incorrecte, car elle n'est pas dysorthographique (seulement agrammaticale) et qu'il n'y a donc pas de raison qu'elle soit traitée différemment de "je partons" (que Vim ne remarquera pas comme agrammatical, puisque la fonction `spell` de Vim ne s'occupe pas de grammaire mais uniquement d'orthographe).
- Par conséquent, les apostrophes et traits d'unions ne sont pas considérés dans cette version comme des `WORDCHARS` mais comme des _word boundaries_.
- Écriture inclusive: auteur·rice, auteurice, auteuricex, ... (Le _stemma_ des mots féminins ou masculins est la forme inclusive.)
- Les mots contenant des ligatures `œ` et `æ` sont doublées de leurs versions non-ligaturées (ex. "oeuvre").
- Aucun nom propre.

sources
-------

J'ai utilisé comme base le dictionnaire de Grammalecte tel qu'il est proposée dans le package Debian [hunspell-fr-comprehensive](https://packages.debian.org/bookworm/hunspell-fr-comprehensive), et qui représente à mes yeux un travail formidable (et probablement gigantesque) dont ce dépôt n'est qu'une simple adaptation. Si j'ai peu modifié la liste des mots (excepté le retranchement des noms propres, l'ajout de préfixes scientifiques comme `socio-` et de suffixes), j'ai en revanche passablement modifié la définition, les noms et la répartition des affixes, en particuliers en ce qui concerne les noms et les adjectifs. Les définitions des verbes sont inchangées. Les _part-of-speech_ (`po:`) ont systématiquement été remplacé par les [_universal part-of-speech tags (upos)_](https://universaldependencies.org/u/pos/).
