## ADDED Requirements

### Requirement: Proposition du MJ envoyée
Le MJ d'une table SHALL pouvoir, depuis la fiche d'un de ses joueurs, proposer de remplacer un don d'origine ou un style de combat ([F4a], EF-PJ-16). Les dons proposés SHALL être de la même catégorie, ni le don remplacé ni un don déjà pris, sauf s'il est répétable. Les choix du don proposé SHALL être faits avant l'envoi. L'écran SHALL montrer l'aperçu avant et après, et n'envoyer la proposition qu'avec un motif.

#### Scenario: Bouton
- **WHEN** Camille, MJ, ouvre la fiche d'Aldric, à Hugo
- **THEN** elle voit « Proposer une modification » ; Hugo ne le voit pas sur sa propre fiche

#### Scenario: Envoi
- **WHEN** Camille propose Doué à la place de Vigilant, avec Histoire, Médecine et Dressage, et un motif
- **THEN** la proposition part en attente pour Hugo, et l'aperçu montrait l'Initiative de +3 à +1

#### Scenario: Motif vide
- **WHEN** le motif est vide
- **THEN** « Envoyer la proposition » est inactif

### Requirement: Réponse lue par le MJ
Sur la fiche de son joueur, le MJ SHALL voir que sa dernière proposition attend une réponse, ou que le joueur l'a refusée, avec son message.

#### Scenario: En attente
- **WHEN** Hugo n'a pas encore répondu
- **THEN** Camille lit « Proposition envoyée à Hugo : en attente de sa réponse. »

#### Scenario: Refusée
- **WHEN** Hugo a refusé avec « Je garde Vigilant. »
- **THEN** Camille lit « Hugo a refusé votre proposition » et son message
