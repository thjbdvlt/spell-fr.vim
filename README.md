dict. orth. fr. pour Vim/Neovim construit à partir du dictionnaire orthographique de Grammalecte (disponible dans Hunspell).

contient:

- la définitions des affixes dans les fichiers `.aff`;
- les listes de mots dans les fichiers `.dic`;
- un Makefile pour les assembler à l'aide de Neovim (`nvim -e "mkspell ..."`).

différences avec le dictionnaire orthographique français par défaut de Vim:

- ne s'occupe que d'orthographe, et pas de grammaire: une forme comme "j'arrivons" ne sera donc pas soulignée comme incorrecte, car elle n'est pas dysorthographique, seulement agrammaticale, il n'y a donc pas de raison qu'elle soit traitée différemment de "je partons" (que Vim ne remarquera pas comme agrammatical, puisque la fonction `spell` de Vim ne s'occupe pas de grammaire mais uniquement d'orthographe).
- aucun nom propre.
- les mots contenant des ligatures `œ` et `æ` sont doublées de leurs versions non-ligaturées (ex. "oeuvre").
