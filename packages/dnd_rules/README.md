# dnd_rules

Moteur de règles pur Dart (cahier §10.3) : aucune base, aucun réseau, aucun Flutter.

## Point d'entrée

```dart
final sheet = computeSheet(CharacterInput.fromJson(stored), ActiveContent(packs));
sheet.armorClass.value;          // 19
sheet.armorClass.sources;        // décomposition (EF-PJ-03)
sheet.integrityErrors;           // règles enfreintes (§11.3), jamais d'exception
sheet.toJson();                  // forme du bloc `expected` des fixtures [D1]
```

- `CharacterInput` : le personnage tel qu'il est stocké (sources et choix, jamais de valeur calculée), format du bloc `input` des fixtures. Les choix des effets `choice` sont rangés par identifiant de choix : `"choices": {"skillful": ["srd:skill:insight"]}`.
- `ActiveContent` : les entités des packs activés pour la table.
- Spécification : `openspec/specs/character-sheet/` (après archivage du change US-03).

Périmètre actuel : personnage de niveau 1. Les niveaux suivants, les sorts et l'inventaire complet arrivent en M1.
