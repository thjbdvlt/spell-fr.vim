dictionnaire orthographique français au format [HunSpell](http://hunspell.github.io/) construit à partir du dictionnaire de [Grammalecte](https://grammalecte.net/), compatible avec Vim/NeoVim.

contenu du dépôt
----------------

dans le dossier [vim/](./vim) se trouvent le fichier compilé (`.spl`) tel qu'il peut être utilisé pour la correction orthographique dans vim, ainsi que les fichiers `st.dic` et `st.aff` adaptés pour le produire. le dossier [morph/](./morph) contient, lui, les fichiers `st.dic` et `st.aff` avec les informations morphologiques, les part-of-speech modifiés pour correspondre aux _universal part-of-speech_: on peut les utiliser pour faire de l'analyse morphologique (le fichier [feats/is_to_feats.csv](feats/is_to_feats.csv) permet de récupérer, sans trop de perte, les FEATS correspondant à chaque flag morphologique). on trouvera également un fichier avec la liste de tous les mots possibles (un par ligne) dans [dump/](./dump). les autres dossiers contiennent les données et scripts utilisées pour produire ces fichiers.

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
