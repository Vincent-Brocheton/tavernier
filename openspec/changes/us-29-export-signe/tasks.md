## 1. Format et signature

- [x] 1.1 Tests puis manifeste : `description`, `author_public_key`, `signature`
- [x] 1.2 Tests puis `signPack`, `verifyPackSignature`, graine et paire Ed25519
- [x] 1.3 Tests puis `nextVersion` et `packChanges`

## 2. Base v9

- [x] 2.1 Tests puis `author_key`, colonnes de `content_pack`, migration et instantané
- [x] 2.2 Tests puis `AuthorKeyStore` et aller-retour d'un pack signé

## 3. App

- [x] 3.1 Tests puis page « Publier une version » [H06] : version, changements, attestation, contrôles
- [x] 3.2 Publication signée dans la base de l'appareil, export par la feuille de partage

## 4. Livraison

- [x] 4.1 Suite complète, revue, PR
