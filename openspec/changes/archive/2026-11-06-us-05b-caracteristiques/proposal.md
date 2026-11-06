# Proposal

## Why

Cartes Trello [US-05](https://trello.com/c/NRrTNP2B) (lot 2, première partie) et US-06 · Répartition des bonus d'Historique. Le lot 1 livre l'assistant et ses étapes Classe, Historique et Espèce. Ce change ajoute les étapes 4 et 5 (cahier §5.1, maquettes [P4], [3a], [3b]).

L'étape Sous-choix est plus vaste que prévu (compétences, bottes, style de combat, don de l'Humain, lignages, choix de classe, sorts de départ) : elle aura son propre change, qui termine le lot 2.

## What Changes

- **Étape 4, Langues [P4] :** le Commun d'office, deux langues courantes à choisir, « Tirer au sort ». Les langues rares ne sont pas proposées, avec la règle affichée.
- **Étape 5, Caractéristiques [3a], [3b], US-06 :**
  - acquisition par points : budget de 27, valeurs de 8 à 15, coût de chaque valeur ;
  - bonus d'Historique : `+2 et +1` ou `+1, +1 et +1`, sur les 3 caractéristiques de l'Historique ;
  - total et modificateur de chaque caractéristique ;
  - une caractéristique non éligible est grisée, avec la règle ;
  - un même caractéristique ne reçoit pas le +2 et le +1.
- **Choix devenu invalide (cahier §5.1) :** après un changement d'Historique, un bonus sur une caractéristique non éligible est signalé par un bandeau et bloque l'étape. Le saut vers l'avant par la liste des étapes le contrôle aussi.
- **`dnd_rules` :** les règles deviennent publiques (coût des valeurs, budget, modificateur, langues de départ), pour que l'interface n'en porte aucune.
- **Kit :** `PointBuyTile`, `BonusToggle`, `StatusBanner`.

## Capabilities

### New Capabilities

Aucune.

### Modified Capabilities

- `character-creation` : étapes Langues et Caractéristiques.
- `ui-kit` : composants de ces étapes.

## Impact

- `apps/game_table/lib/creation/` : `languages_step.dart`, `abilities_step.dart`, brouillon, ARB.
- `packages/dnd_rules` : `creation_rules.dart`.
- `packages/dnd_ui_kit` : composants et tests.

**Hors périmètre :**
- **Valeurs standard et tirage aléatoire :** la méthode est imposée par la table (M2). Sans table, ce change propose l'acquisition par points.
- **Panneau « Aperçu » de [3b]** (PV, attaque, décomposition) : il demande un personnage complet, il arrive avec le récapitulatif. Le tableau donne déjà le total et le modificateur.
- **Conseil de classe** de [3b] et suggestions (US-32).

**Point à relire :** le SRD (p. 22) dit « 27 points à dépenser », sans dire s'il faut tout dépenser. Le moteur et [3b] exigent 27 / 27 : l'étape reste bloquée tant qu'il reste des points.
