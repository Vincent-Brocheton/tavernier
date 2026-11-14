## ADDED Requirements

### Requirement: Séances stockées
La base locale SHALL garder les séances et leurs présences prévues dans des tables synchronisées (`session`, `session_attendance`). `SessionStore` SHALL :
- créer une séance (table, titre, date, état `planned` par défaut) et rendre son identifiant ;
- modifier son titre, sa date et son état ;
- la supprimer avec ses présences ;
- suivre les séances d'une table, de la plus récente à la plus ancienne, chacune avec son numéro « Séance n » ;
- suivre et cocher les présences prévues d'une séance.

Le numéro SHALL suivre l'ordre des dates, puis l'ordre de création pour deux séances le même jour, en partant de 1.

#### Scenario: Numéros des séances
- **WHEN** Brumeval a des séances le 9, le 16 et le 23 octobre
- **THEN** la liste rend la séance du 23 octobre en premier, numérotée 3, et celle du 9 octobre en dernier, numérotée 1

#### Scenario: Séance déplacée
- **WHEN** la séance du 9 octobre passe au 30 octobre
- **THEN** elle devient la séance 3, et les deux autres deviennent 1 et 2

#### Scenario: Présences
- **WHEN** le MJ coche Aldric et Mira, puis décoche Mira
- **THEN** seul Aldric est prévu à la séance

#### Scenario: Séance supprimée
- **WHEN** le MJ supprime une séance
- **THEN** ses présences disparaissent avec elle
