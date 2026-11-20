## ADDED Requirements

### Requirement: Vue du combat au serveur
La table `combat_view` SHALL porter une vue par rencontre : la rencontre, sa table et le JSON de la vue.
- Elle SHALL être lisible par les membres et le MJ de la table.
- Seul le MJ d'une table active SHALL pouvoir l'écrire.
- Sa rencontre SHALL être de sa table.
- PowerSync SHALL la transmettre aux membres.

#### Scenario: Lue par un joueur
- **WHEN** Camille, MJ, publie la vue du relais du Sel
- **THEN** Hugo, joueur de la table, la lit, et Zoé, hors de la table, ne la voit pas

#### Scenario: Écrite par le MJ seul
- **WHEN** Hugo tente de publier ou de modifier la vue
- **THEN** l'écriture est refusée, ou n'a pas d'effet

### Requirement: Demandes des joueurs au serveur
La table `combat_request` SHALL porter les demandes d'un joueur pour son PJ.
- Seul le propriétaire d'un PJ de la table SHALL pouvoir en insérer, en son nom, sur une table active et pour une rencontre de cette table.
- Le MJ et l'auteur SHALL les lire.
- Le MJ seul SHALL pouvoir les supprimer.
- PowerSync SHALL les transmettre au MJ et à leur auteur.

#### Scenario: Pour son PJ
- **WHEN** Hugo envoie des dégâts pour Aldric
- **THEN** la demande est acceptée, Camille la lit et Inès ne la voit pas

#### Scenario: Pour le PJ d'un autre
- **WHEN** Hugo envoie une demande pour Mira
- **THEN** elle est refusée

#### Scenario: Table archivée
- **WHEN** la table est archivée
- **THEN** une nouvelle demande est refusée
