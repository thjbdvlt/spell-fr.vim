dict. orth. fr. pour Vim construit à partir du dictionnaire de [Grammalecte](https://grammalecte.net/).

### contenu du dépôt

- la définitions des affixes dans les fichiers `.aff`;
- les listes de mots dans les fichiers `.dic`;
- un Makefile pour les assembler à l'aide de Vim (`vim -e "mkspell ..."`).

### différences avec le dictionnaire orthographique français par défaut de Vim

- ne s'occupe que d'orthographe, et pas de grammaire: une forme comme "j'arrivons" ne sera pas soulignée comme incorrecte, car elle n'est pas dysorthographique -- seulement agrammaticale -- et qu'il n'y a donc pas de raison qu'elle soit traitée différemment de "je partons" (que Vim ne remarquera pas comme agrammatical, puisque la fonction `spell` de Vim ne s'occupe pas de grammaire mais uniquement d'orthographe).
- les mots contenant des ligatures `œ` et `æ` sont doublées de leurs versions non-ligaturées (ex. "oeuvre").
- aucun nom propre.
- écriture inclusive: auteur, autrice, auteur-rice, auteurice.

### sources

j'ai utilisé comme base le dictionnaire de Grammalecte tel qu'il est proposée dans le package debian [hunspell-fr-comprehensive](https://packages.debian.org/bookworm/hunspell-fr-comprehensive). si j'ai peu modifié la liste des mots (excepté le retranchement des noms propres), j'ai en revanche passablement modifié la définition, les noms et la répartition des affixes, en particuliers en ce qui concerne les noms et les adjectifs.
