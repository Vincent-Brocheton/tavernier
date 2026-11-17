# Proposal

## Why

Carte Trello [US-18](https://trello.com/c/0XIAKPIF), lot b. Le lot a a posé les PNJ dans la base. Ce lot donne au MJ les écrans du **bloc de stats** :
- créer un PNJ à partir d'un monstre du bestiaire ;
- le retrouver dans la liste de la table ;
- lire son profil ;
- régler son attitude ;
- le dupliquer.

Exigences **EF-PNJ-01** (bloc de stats), **EF-PNJ-02** (dupliqué, rangé en dossiers) et **EF-ACT-06** (attitude persistante). Planches [G5], [F4] et [C2].

## What Changes

- **Onglet « PNJ »** de la page d'une table, pour le MJ seul, après « Séances » ([F4]) :
  - bouton « Nouveau PNJ » ;
  - filtres « Tous · 4 », « Hostiles · 1 », « Amicaux · 1 », « Indifférents · 2 » ;
  - PNJ rangés par dossier (sans dossier en dernier), avec initiale, nom, « Chef de bande · FP 2 · SRD » et badge d'attitude (icône et libellé) ;
  - « Aucun PNJ » quand la table n'en a pas.
- **Nouveau PNJ** ([G5], bloc de stats) :
  - « Nom * » ;
  - « Partir de » : choix d'un monstre des packs actifs, avec recherche par nom, et « FP n · pack » ;
  - « Dossier » : texte libre ou dossier existant ;
  - « Attitude initiale », Indifférent par défaut ;
  - « Annuler » et « Créer le PNJ », qui ouvre sa fiche.
- **Fiche du PNJ** ([C2]) :
  - en-tête « PNJ · Les Marches de Brumeval » et « Dupliquer » ;
  - nom, puis « Humanoïde de taille M ou P, Neutre » et « Variante de « Chef de bande » · SRD 5.2.1 » ;
  - CA, Initiative « +3 (13) », PV « 52 (8d8 + 16) » et Vitesse en mètres ;
  - les six caractéristiques, avec leur modificateur et leur JS ;
  - Compétences, Vulnérabilités, Résistances, Immunités, Équipement, Sens, Langues et FP « 2 (450 PX ; BM +2) » ;
  - Traits, Actions, Actions Bonus, Réactions et Actions légendaires, chacun avec son nom, son usage (« (recharge 5–6) », « (2/jour) ») et son texte ;
  - « Attitude envers le groupe » : Amical, Indifférent ou Hostile, enregistré tout de suite et gardé entre les séances.
- **Dupliquer** : crée « Varga la Balafrée (copie) » et ouvre sa fiche.

## Capabilities

### New Capabilities

Aucune.

### Modified Capabilities

- `tables` : onglet PNJ, nouveau PNJ en bloc de stats, fiche du PNJ, attitude, duplication.

## Impact

- `apps/game_table/lib/npcs/` (nouveau) :
  - providers ;
  - onglet ;
  - nouveau PNJ et choix du monstre ;
  - fiche ;
  - `StatBlockView`.
- `tables/table_page.dart` (onglet), `main.dart` (routes) et ARB.
- Tests de widgets.

**Hors périmètre :**
- **Fiche complète** ([G5], deuxième carte) : lot d. Ce lot ne montre que le bloc de stats.
- **Bloc vide et modification du bloc** (« Modifier ») : un bloc se modifie avec un éditeur à venir. Ici, un PNJ part toujours d'un monstre.
- **Informations cachées**, renommage et changement de dossier : lot c.
- Filtre « Pas encore rencontrés », lignes « Rencontrée séance 12 » et « Utilisée dans », statut « Capturée » : ils demandent les rencontres (US-19).
- DD d'Influence et tentatives mémorisées : US-22.
