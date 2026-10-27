# Proposal

## Why

Carte Trello [T-04 · Saisie SRD : classes, sous-classes, sorts, objets](https://trello.com/c/DsZNVvZy/27-t-04-saisie-srd-classes-sous-classes-sorts-objets), première de M1 (cahier §14.1, risque « Saisie du SRD 5.2.1 français »). Le pack SRD ne contient que l'échantillon de M0 (Guerrier, 4 Historiques). La création de personnage (US-05), la fiche (US-07) et les sorts (US-09) ont besoin du SRD complet.

T-04 représente environ un millier d'entités. La carte est livrée en cinq lots, chacun avec son change et sa pull request ; elle passe dans « Fait » avec le dernier :

1. **Sorts** (ce change) : les 339 sorts du SRD 5.2.1.
2. **Classes I** : Barbare, Barde, Clerc, Druide, Ensorceleur, Magicien, avec leurs sous-classes, aptitudes et listes de sorts.
3. **Classes II** : Moine, Occultiste, Paladin, Rôdeur, Roublard, et la complétion du Guerrier.
4. **Origines et équipement** : les 9 espèces, tous les dons et le reste de l'équipement.
5. **Objets magiques**.

Les sorts passent en premier parce que tout le reste les cite : aptitudes de classe, lignages d'espèce, dons, objets.

## What Changes

- **Nouveau type d'entité `spell`** (format `.dndpack` v1, ajout compatible). Il porte :
  - le niveau (0 pour un sort mineur) et l'école ;
  - le temps d'incantation et la durée, tels que dans le SRD ;
  - le rituel et la concentration ;
  - la portée, en pieds ou par genre (personnelle, contact, champ de vision, illimitée, spéciale) ;
  - les composantes V, S, M, avec le texte du composant matériel, son coût en pc et s'il est consommé ;
  - le texte complet du sort, y compris « Emplacement de niveau supérieur » et « Amélioration de sort mineur ».
- **Pas de liste de classes dans le sort.** Une classe déclarera sa liste de sorts (`spell_list`) aux lots 2 et 3, comme les listes « Liste des sorts de … » du SRD. Cela évite une dépendance circulaire : les classes, espèces et dons citent des sorts, et les sorts ne citent rien.
- **Extraction semi-automatique** : `fvm dart run tools/srd_builder/bin/srd_builder.dart extract-spells`.
  - **Entrée :** le texte du PDF en ordre de lecture (`pdftotext`, sans option de mise en page).
  - **Nettoyage :** l'outil retire les en-têtes et pieds de page, puis recolle les paragraphes coupés par une colonne ou une page.
  - **Sortie :** il écrit un fichier par sort dans `sources/spell/`.
  - **Nom anglais :** une table de correspondance relue (`spell_slugs.tsv`) donne le slug anglais de chaque sort.
- **Relecture** : un test vérifie des sorts témoins contre le SRD, avec leur page : Boule de feu, Aspersion acide, Bénédiction, Souhait, Rappel à la vie, Bouclier. Il vérifie aussi des comptes globaux : 339 sorts, dont 27 mineurs ; tous les niveaux de 0 à 9 et toutes les écoles présents.
- **Base locale** : `PackStore` importe et exporte le type `spell` dans la table `spell` existante (§11.1), et la recherche plein texte trouve les sorts.

## Capabilities

### New Capabilities

- `content-pack` : format `.dndpack`, entités et leurs contrôles, build du pack SRD. La spec rattrape les règles livrées en M0 (US-02, T-03), comme le prévoit CLAUDE.md, et ajoute le type `spell` et les sorts du SRD.

### Modified Capabilities

- `local-database` : stockage, aller-retour et recherche des sorts.

## Impact

- `packages/dnd_content` : `SpellData` (freezed), lecteur du type `spell`, validation.
- `packages/dnd_data` : import et export du type `spell` dans `PackStore`, sans changement de schéma (la table `spell` existe depuis US-04).
- `tools/srd_builder` : commande `extract-spells`, table `spell_slugs.tsv`, 339 fichiers `sources/spell/*.json`, tests.
- `docs/packs/FORMAT_DNDPACK.md` : type `spell` documenté.
- `apps/game_table/assets/packs/srd-5.2.1-fr.dndpack` régénéré.
- **Outil externe** : `pdftotext` (poppler, fourni avec Git pour Windows), seulement pour l'extraction. Le build du pack n'en dépend pas : les sources JSON extraites sont commitées.

**Hors périmètre :**
- **Listes de sorts des classes :** elles arrivent avec les classes (lots 2 et 3).
- **Effets calculés des sorts :** ils ne passent pas par le DSL v1 (cahier §10.3 : les sorts sont descriptifs ; les jets et dégâts arrivent avec le combat, M3).
- **Pack anglais :** V1.5. Les slugs anglais le préparent.
