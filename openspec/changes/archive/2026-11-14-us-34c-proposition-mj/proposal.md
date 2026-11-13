# Proposal

## Why

Carte Trello [US-34](https://trello.com/c/p0kavJYL), troisième et dernier lot : le MJ envoie une proposition structurelle à un joueur depuis sa fiche (**EF-PJ-16**, écran [F4a], composant `ProposalBanner` §2.44). Le lot b a posé le stockage, les droits et la réception par le joueur.

## What Changes

- **Fiche d'un joueur ouverte par le MJ de sa table** : bouton « Proposer une modification ».
- **Écran [F4a]** (`/characters/:id/proposer`) :
  - « Proposer une modification à Hugo », puis « Aldric Varenne · hors combat, une modification structurelle passe par l'accord du joueur. » ;
  - type « don » : « Remplacer » (un don d'origine ou un style de combat de la fiche), « Par » (les dons éligibles), et les choix du don proposé (Doué : 3 compétences) ;
  - aperçu avant et après, le même que celui du joueur ;
  - « Motif (obligatoire, visible du joueur) », « Annuler » et « Envoyer la proposition ».
- **Dons éligibles** : même catégorie que le don remplacé, ni lui ni un don déjà pris (sauf répétable). Les dons d'origine et les styles de combat n'ont pas de prérequis à vérifier.
- **Suivi par le MJ sur la fiche** :
  - « Proposition envoyée à Hugo : en attente de sa réponse. » ;
  - ou « Hugo a refusé votre proposition » avec son message.

  Une proposition acceptée est dans l'historique (lot b).

## Capabilities

### New Capabilities

Aucune.

### Modified Capabilities

- `character-sheet` : envoi d'une proposition par le MJ, suivi de la réponse.
- `local-database` : propositions d'une fiche pour son MJ, table de la fiche.

## Impact

- `packages/dnd_data/` : `CharacterStore.watchProposals`, réponse du joueur dans `CharacterProposal`, table de la fiche dans `access`.
- `apps/game_table/` :
  - `sheet/proposal_page.dart` (nouveau) et sa route ;
  - `proposal_banner.dart` : aperçu partagé, vue du MJ, suivi ;
  - bouton sur la fiche ;
  - ARB ;
  - tests.

**Hors périmètre :**
- **Initié à la magie** : ses choix dépendent d'une liste de sorts. Il n'est pas proposé.
- **Dons généraux** (niveau 4 et plus) : leurs prérequis seraient à vérifier. Ils ne sont pas remplaçables ici.
- **Niveau et Historique** : le format le permet (lot b), mais leurs écrans ne sont pas faits.
- **Compétences déjà maîtrisées** : elles restent proposables dans les choix du don. L'aperçu montre seulement ce qui change.
- **« Pour corriger sans accord, utilisez une dérogation »** ([F4a]) : les dérogations restent dans le panneau de revue.
