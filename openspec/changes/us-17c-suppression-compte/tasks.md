## 1. Serveur

- [x] 1.1 pgTAP puis migration : `delete_my_account` (joueur, MJ d'une table archivée, sans session), table sans MJ en lecture seule (fiche, emplacement)

## 2. Base et app

- [x] 2.1 Tests puis `CharacterStore.access` (table sans MJ) et `sheetEditableProvider`
- [x] 2.2 Tests puis `deleteAccount` (passerelle et `SessionActions`) : serveur, puis effacement et déconnexion ; échec sans effacement
- [x] 2.3 Page [T15], route, entrée du profil ([T14], [A7]), ARB ; tests de widgets
- [x] 2.4 Vérification dans le navigateur : entrée absente sans compte, page [T15] au format téléphone. La suppression réelle reste à essayer sur le projet hébergé, par le porteur de projet
