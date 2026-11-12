## 1. Serveur

- [x] 1.1 Tests pgTAP : rejoindre (code valide, inconnu, expiré, révoqué, table archivée, déjà membre, freinage), retrait d'un joueur (fiche archivée, lecture seule)
- [x] 1.2 Migration : `join_table`, `join_attempt`, trigger de retrait, `can_write_character`

## 2. Données

- [x] 2.1 Tests puis invitations (`createInvite`, `watchInvite`, `revokeInvite`), membres (`watchMembers`, `removeMember`)
- [x] 2.2 Tests puis requêtes réactives des tables (`watchList`, `watch`)

## 3. App

- [x] 3.1 Fournisseurs réactifs ; onglet Membres et retrait ; tests
- [x] 3.2 Carte d'invitation (QR, code, copier, partager, expiration, révoquer) ; tests
- [ ] 3.3 Vérification dans le navigateur
