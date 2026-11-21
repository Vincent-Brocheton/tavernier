# Design

## Moteur (`packages/dnd_rules/lib/src/sandbox.dart`)

### `sandboxCharacter`

```dart
CharacterInput sandboxCharacter(
  ActiveContent content, {
  required String classId,
  required int level,
  String? subclassId,
  String speciesId = 'srd:species:human',
  String backgroundId = 'srd:background:soldier',
  bool shield = false,
  List<FeatInput> feats = const [],
  List<ItemInput> items = const [],
})
```

- **Caractéristiques** : `suggestedScores` (tableau standard de la classe), puis `suggestedBonuses` sur les caractéristiques de l'Historique (2-1).
- **Classe** : une seule classe, au niveau demandé. La sous-classe vient à partir de `subclassLevel`. Les compétences viennent de `suggestedSkills`.
- **Don d'origine** : celui de l'Historique, de source `background`.
- **Taille** : la première de l'espèce.
- **Équipement** : l'option A de départ.
  - La première armure (hors bouclier) et la première arme sont portées.
  - Le bouclier du SRD (`srd:armor:shield`) est ajouté porté si demandé.
  - Les objets en plus sont ajoutés tels quels.
- **Choix non faits** (Style de combat, Polyvalent, Compétent…) : la fiche les signale en règles enfreintes. Elles sont les mêmes avec et sans l'entité, donc `compareSheets` ne les rend pas.

### `compareSheets`

```dart
SheetComparison compareSheets(ComputedSheet? before, ComputedSheet after)
```

- **`SheetRow`** : `kind` (`armorClass`, `hitPoints`, `initiative`, `speed`, `passivePerception`, `savingThrow`, `skill`, `resource`, `darkvision`, `attacksPerAction`, `spellSlot`, `attack`), `ref` (code de caractéristique, identifiant de compétence, de ressource ou d'arme, niveau d'emplacement), `before`, `after` et `sources`.
- **Valeurs** :
  - entiers pour la plupart ;
  - pour une attaque, le texte « +7 · 1d8 + 4 », comme sur la fiche ;
  - pour une ressource ou un emplacement absent, 0.
- **Sources** : les libellés des contributions de la valeur avec qui ne sont pas dans la valeur sans. Ce sont des identifiants d'entité (aptitude, don, objet) ou des codes (`dex`, `proficiency`). L'app ne nomme que les identifiants.
- **`SheetComparison`** : `rows`, plus `addedErrors`, les règles enfreintes de la fiche avec qui ne sont pas dans la fiche sans (comparées par règle et chemin).

## App (`apps/game_table/lib/homebrew/sandbox_page.dart`)

- **`SandboxPage(draft, entities, entityId)`** :
  - `entities` est le brouillon tel qu'il serait enregistré.
  - Le contenu du test est le contenu actif de l'appareil, plus un `ContentPack` fait du manifeste et des entités du brouillon qui se lisent. Un brouillon incomplet se teste donc.
- **Fiche sans / avec, par type** :
  - **Don** : `feats` plus le don, de source `test`.
  - **Historique, Espèce** : `backgroundId` ou `speciesId` remplacé.
  - **Classe** : `classId` est l'entité, et il n'y a pas de fiche sans.
  - **Sous-classe** : `classId` est le parent ; la fiche sans n'a pas de sous-classe.
  - **Arme, armure, objet magique** : l'objet en plus, porté, harmonisé s'il le demande (`requiresAttunement`).
  - **Monstre** : `StatBlockView` de son profil.
- **Calcul** : `computeSheet` est appelé dans un `try`. Une exception devient « le calcul échoue : … » dans le résultat, et le tableau reste vide.
- **Mise en page** : une colonne sur téléphone, trois panneaux dès 900 dp de large (contrôles, tableau, résultat), comme [H04].
  - Chaque ligne a son libellé, « Sans », « Avec » et sa source. La valeur avec est en accent quand elle diffère.
  - L'information ne passe jamais par la couleur seule : une flèche et le libellé de la source l'accompagnent.
- **Résultat du test** :
  - « Toutes les valeurs se calculent sans erreur au niveau N. », ou les règles enfreintes ajoutées par l'entité ;
  - « Reste à corriger » : les problèmes de `checkDraft` dont le chemin vise l'entité ou l'une de ses aptitudes.
- **Éditeur** :
  - le bouton « Tester sur un personnage » (icône `science`) est dans la barre de l'éditeur d'un type testable ;
  - `_save` est découpé : `_draftEntities()` construit la liste des entités, que `_save` enregistre et que le test lit.

## Choix

- **Un prétiré construit, pas une fiche réelle** : EF-HB-03 parle d'un personnage de test. Construire le prétiré à partir du contenu le rend disponible pour toute classe, homebrew comprise, sans lire les fiches de l'utilisateur.
- **Comparaison dans `dnd_rules`** : elle est pure et testable, et la couverture de 95 % s'y applique.
