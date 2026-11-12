## 1. Serveur

- [ ] 1.1 Tests pgTAP : rejoindre (code valide, inconnu, expiré, révoqué, table archivée, déjà membre, freinage), retrait d'un joueur (fiche archivée, lecture seule)
- [ ] 1.2 Migration : `join_table`, `join_attempt`, trigger de retrait, `can_write_character`

## 2. Données

- [ ] 2.1 Tests puis invitations (`createInvite`, `watchInvite`, `revokeInvite`), membres (`watchMembers`, `removeMember`)
- [ ] 2.2 Tests puis requêtes réactives des tables (`watchList`, `watch`)

## 3. App

- [ ] 3.1 Fournisseurs réactifs ; onglet Membres et retrait ; tests
- [ ] 3.2 Carte d'invitation (QR, code, copier, partager, expiration, révoquer) ; tests
- [ ] 3.3 Vérification dans le navigateur
