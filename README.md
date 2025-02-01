Fichiers Hunspell pour le français pour la correction orthographique avec [Vim](https://www.vim.org/)/[NeoVim](https://neovim.io/)) et pour l'analyse morphologique.

Le `makefile` permet de produire deux versions des fichiers `.aff` et `.dic`:

- Une version compatible avec Vim, simplifiée et peu intéressante pour l'analyse morphologique.
- Une version complète, contenant les informations morphologiques complètes des mots, avec les *part-of-speech* conformes à ceux définis par [*Universal Dependencies*](https://universaldependencies.org/u/feat/index.html) -- mais incompatible avec Vim. Pour l'analyse morphologique basée sur les *Universal Features* (temps verbaux, nombre, genre, etc.), on pourra utiliser le fichier [feats_lookups.tsv](./feats_lookup.tsv).

```bash
# pour installer la version compatible avec Vim:
make fr.utf-8.spl # ou directement `make install`

# pour les versions complètes
make fr_ud.dic fr_ud.aff
```

différences avec le dictionnaire orthographique français par défaut de Vim
--------------------------------------------------------------------------

- Ne s'occupe que d'orthographe, et pas de grammaire: une forme comme "j'arrivons" ne sera pas identifiée comme incorrecte, car elle n'est pas dysorthographique (seulement agrammaticale) et qu'il n'y a donc pas de raison qu'elle soit traitée différemment de "je partons" (que Vim ne remarquera pas comme agrammatical, puisque la fonction `spell` de Vim ne s'occupe pas de grammaire mais uniquement d'orthographe).
- Par conséquent, les apostrophes et traits d'unions ne sont pas considérés dans cette version comme des `WORDCHARS` mais comme des _word boundaries_.
- Écriture inclusive: auteur·rice, auteurice, auteuricex, ... (Le _stemma_ des mots féminins ou masculins est la forme inclusive.)
- Les mots contenant des ligatures `œ` et `æ` sont doublées de leurs versions non-ligaturées (ex. "oeuvre").
- Aucun nom propre par défaut.

formats d'écriture inclusive
-----

L'écriture inclusive n'est supportée, dans Vim, qu'avec le point médian et le point standard. Les formes réalisées avec un tiret ne sont pas soulignées comme fausses, mais sont analysées comme des mots composés, et ne sont par conséquent pas vérifiées (_auteur-euse-s-euse_ ne sera par exemple pas reconnu comme dysorthographique). Pour l'analyse morphologique avec Hunspell, les formes avec le tirets sont correctement analysées (Vim ne supporte pas `ICONV`, utilisée pour les points standards).

mots composés
-------------

Il n'y a pas de vérification des mots composés dans Vim (pour éviter des faux positifs).
Mais l'analyse morphologique avec Hunspell les prends en compte, de façons assez sommaire, selon les formes suivantes (sans trait d'union):

- préfixe adverbial + nom (*paralittérature*)
- préfixe adverbial + adjectif (*épigénétique*)

sources
-------

J'ai utilisé comme base le dictionnaire de Grammalecte tel qu'il est proposée dans le package Debian [hunspell-fr-comprehensive](https://packages.debian.org/bookworm/hunspell-fr-comprehensive), et qui représente à mes yeux un travail formidable (et probablement gigantesque) dont ce dépôt n'est qu'une simple adaptation. Si j'ai peu modifié la liste des mots (excepté le retranchement des noms propres, l'ajout de préfixes scientifiques comme `socio-` et de suffixes), j'ai en revanche passablement modifié la définition, les noms et la répartition des affixes, en particuliers en ce qui concerne les noms et les adjectifs. Les définitions des verbes sont inchangées. Les _part-of-speech_ (`po:`) ont systématiquement été remplacé par les [_universal part-of-speech tags (upos)_](https://universaldependencies.org/u/pos/).
