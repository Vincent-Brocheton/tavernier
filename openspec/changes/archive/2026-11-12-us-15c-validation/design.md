# Design

## Serveur

- `character` gagne `submit_message text` et `review_comment text`.
- `guard_character` (us-15b) refuse :
  - `submit_message` changé par un autre que le propriétaire ;
  - `review_comment` changé par un autre que le MJ ;
  - `owner_user_id` changé, sauf par le MJ de la table, vers un membre, sur une fiche non archivée.
- `archive_member_characters` supprime aussi les emplacements du joueur retiré.
- `guard_pc_slot` laisse le MJ changer le joueur d'un emplacement ; c'était déjà permis au MJ.

Transférer, c'est changer `pc_slot.player_user_id` et `character.owner_user_id` dans une même transaction locale. `apply_crud` en fait une transaction serveur.

## Données

- `CharacterStore` :
  - `submit(id, message)` : statut `submitted` et message ;
  - `review(id, validated:, comment:)` : `validated` ou `changes_requested`, et commentaire ;
  - `withdraw(id)` remplace l'appel direct `setStatus(id, 'draft')`.
- `TableStore.transferSlot(slotId, characterId, userId)`.
- `PcSlot` gagne `submitMessage` et `reviewComment`.

## Contrôles du panneau

Calculés dans l'app à partir de la fiche locale (le MJ la reçoit par la synchronisation) :
- **méthode** : `baseScores.method == table.statMethod` ;
- **niveau** : somme des niveaux de classe == niveau de départ ;
- **intégrité** : `computeSheet(input, contenu).integrityErrors` vide, sinon la liste.

Chaque contrôle s'affiche avec une icône (validé ou alerte) et un libellé : la couleur ne porte jamais seule l'information. Un contrôle en échec n'empêche pas de valider : le MJ décide.

## Mise en page

- **Desktop** : le panneau occupe une troisième colonne de l'onglet Membres, comme sur [T10].
- **Téléphone** : il passe en tête de l'onglet, une carte par fiche.
