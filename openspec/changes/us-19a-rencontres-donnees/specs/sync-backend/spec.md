## ADDED Requirements

### Requirement: Rencontres au serveur
Le serveur SHALL garder les rencontres d'une table (`encounter`) :
- séance facultative, de la même table ;
- titre non vide ;
- état (`draft`, `ready`, `running` ou `finished`, `draft` par défaut) ;
- mode de PV (`average` ou `roll`, `average` par défaut) ;
- position et date de création.

Il SHALL aussi garder leurs groupes d'adversaires préparés (`encounter_group`) : sorte (`monster` ou `npc`), référence, quantité de 1 à 30, initiative commune et position.

Seul le MJ de la table SHALL les lire, les recevoir et les écrire, et l'écriture SHALL être refusée sur une table archivée ou sans MJ. Supprimer une rencontre SHALL supprimer ses groupes ; supprimer une séance SHALL laisser ses rencontres en réserve.

#### Scenario: Rencontre du MJ
- **WHEN** Camille crée « Le relais du Sel » dans la séance 12 de Brumeval, avec 2 vétérans
- **THEN** la rencontre et son groupe sont enregistrés, en brouillon, et Camille les reçoit

#### Scenario: Les joueurs ne voient pas les rencontres
- **WHEN** Hugo lit ou synchronise
- **THEN** il ne reçoit ni rencontre ni groupe, et le serveur refuse qu'il en crée

#### Scenario: Quantité hors bornes
- **WHEN** Camille enregistre 0 ou 31 loups
- **THEN** le serveur refuse le groupe

#### Scenario: Séance d'une autre table
- **WHEN** Camille range une rencontre dans une séance d'une autre table
- **THEN** le serveur la refuse

#### Scenario: Séance supprimée
- **WHEN** la séance 12 est supprimée
- **THEN** ses rencontres restent, sans séance
