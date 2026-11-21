# Proposal

## Why

Carte Trello [US-28](https://trello.com/c/peDg4heE) : « En tant que créateur, je teste mon entité sur un personnage de test (bac à sable) avant de la publier. » Exigence **EF-HB-03** ; cahier §7.2 ; planche [H04].

Les éditeurs d'US-27 vérifient la forme d'une entité (`checkDraft`). Il manque l'aperçu de son effet sur une fiche calculée : l'auteur doit voir ce que son aptitude, son don ou son objet change, au niveau et avec l'équipement voulus, sans toucher une fiche réelle. EF-HB-11 permet de tester une progression incomplète ; seule la publication est bloquée.

## What Changes

- **Moteur (`dnd_rules`)** :
  - `sandboxCharacter` : un prétiré construit à partir du contenu. Il a une classe et un niveau, une sous-classe facultative, et il est Humain et Soldat par défaut. Ses valeurs suivent les suggestions de la création : tableau standard de la classe, bonus 2-1, compétences, don d'origine. Il porte l'équipement de départ A, et un bouclier s'il le faut.
  - `compareSheets` : les lignes « sans » et « avec » de [H04].
    - Toujours : CA, PV max, Initiative, Vitesse, Perception passive, attaques.
    - Si elles changent : chaque JS, compétence, ressource, Vision dans le noir, attaques par action, emplacements de sorts.
    - Pour chaque ligne, les sources qui apparaissent avec l'entité.
- **App (`lib/homebrew/sandbox_page.dart`, [H04])** :
  - « Tester sur un personnage » dans l'éditeur d'entité. Il teste l'entité telle qu'elle est à l'écran, sans l'enregistrer.
  - Panneau « Personnage de test » : base prétirée (une par classe), niveau, « Porte un bouclier ».
  - Tableau Valeur / Sans / Avec / Source.
  - « Résultat du test » :
    - les règles enfreintes par l'entité, sur la fiche calculée ;
    - les problèmes de la vérification qui la concernent, à corriger avant de publier ;
    - un calcul qui échoue, signalé sans planter.
  - Bandeau « Bac à sable : aucune fiche réelle n'est modifiée ». Rien n'est écrit en base.
- **Ce qui est testé, par type** :
  - Don : ajouté au prétiré.
  - Historique et Espèce : à la place de Soldat ou d'Humain.
  - Classe : prétiré de cette classe, sans colonne « Sans ».
  - Sous-classe : prétiré de la classe parente, à partir du niveau de sous-classe.
  - Arme, armure, objet magique : porté, et harmonisé s'il le demande.
  - Monstre : aperçu de son profil, avec le bloc de stats de [C2].
  - Sort et objet courant : rien à calculer sur une fiche, donc pas de test.

## Capabilities

### New Capabilities

### Modified Capabilities
- `homebrew` : bac à sable d'une entité (créée par US-27).
- `character-sheet` : prétiré de test et comparaison de deux fiches.

## Impact

- `packages/dnd_rules` : `sandbox.dart`, avec tests.
- `apps/game_table` : `lib/homebrew/sandbox_page.dart`, `entity_editor.dart` (bouton, entités construites sans enregistrer), ARB, tests.
- Pas de changement de format, de base ni de synchronisation.

## Hors périmètre

- Personnage de test tiré des fiches réelles de l'utilisateur : le prétiré suffit pour EF-HB-03, et une fiche réelle n'est jamais touchée.
- Choix d'un trait à options (sous-lignée, Style de combat) dans le bac à sable : le prétiré prend la première option.
- Publication (US-29).
