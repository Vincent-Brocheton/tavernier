## 1. Lot a : import et duplication

- [x] 1.1 Tests puis `inspectImport` et `rebrandPack`
- [x] 1.2 Tests puis `pack_file` (schéma v10) et `PackLibrary`
- [x] 1.3 Tests puis page d'import [H08] / [H09], conflits de noms
- [x] 1.4 Tests puis « Packs importés » et « Dupliquer pour modifier »
- [x] 1.5 Suite complète, revue, PR du lot a

## 2. Lot b : activation et diffusion

- [x] 2.1 Specs et design du lot b
- [x] 2.2 Migration Supabase : `table_pack.file_sha256`, bucket `packs` et droits, tests pgTAP
- [x] 2.3 Tests puis base v11, `TableStore` (activer, retirer, suivre), `PackLibrary.file`
- [x] 2.4 Tests puis contenu actif avec les packs des tables, téléchargement chez les membres
- [x] 2.5 Tests puis carte « Packs » de la configuration, activation par le MJ, publication dans la bibliothèque
- [x] 2.6 Suite complète, revue, PR du lot b

## 3. Lot c : bannissement, compendium, contenu figé par fiche

- [x] 3.1 Specs et design du lot c1 (EF-HB-10, EF-CMP-01)
- [x] 3.2 Tests puis `ActiveContent.withBanned`
- [x] 3.3 Tests puis `TableStore` : bannir, rétablir, suivre
- [x] 3.4 Tests puis carte « Packs » : entités bannies ; contenu de la création, de la montée de niveau et de la fiche
- [x] 3.5 Tests puis compendium [K1], [K2], [K5]
- [x] 3.6 Suite complète, revue, PR du lot c1
- [x] 3.7 Specs et design du lot c2 (EF-PJ-14, [H9], [H10])
- [x] 3.8 Tests puis `content_refs.dart` et `ActiveContent.withOverrides`
- [x] 3.9 Tests puis `CharacterStore` : références, choix et journal, fiches touchées
- [x] 3.10 Tests puis fiche : contenu figé, alerte et comparaison [H10], historique
- [x] 3.11 Tests puis carte « Packs » : nouvelle version annoncée [H9]
- [x] 3.12 Suite complète, revue, PR du lot c2
