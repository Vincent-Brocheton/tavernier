## ADDED Requirements

### Requirement: Séance en cours
La page d'une séance en cours ([S3]) SHALL s'intituler « Séance en cours », lister les rencontres de la séance avec leur état, et porter « Clore la séance ».

#### Scenario: Séance ouverte
- **WHEN** Camille ouvre la séance en cours
- **THEN** elle voit « Séance en cours », ses rencontres, dont « Les chiens de Varga », et « Clore la séance »

### Requirement: Clôture d'une table en PX
La clôture ([S4]) SHALL montrer les rencontres jouées avec leurs rounds et PX, le total, et pour chaque PJ ses PX gagnés et sa progression vers le niveau suivant. Elle SHALL proposer pour chaque rencontre non jouée « Reporter à la séance n », si une séance est prévue après, « Garder sans séance » ou « Supprimer ». « Clore la séance n » SHALL ajouter les PX aux fiches, avec leur historique, appliquer le sort choisi et clore la séance (EF-SEA-03).

#### Scenario: [S4]
- **WHEN** Camille clôt une séance où Aldric et Mira gagnent 75 puis 750 PX, avec une rencontre non jouée et une séance prévue après
- **THEN** elle lit 1 650 PX au total, « +825 » et « 0 → 825 / 14 000 (niv. 6) » pour chacun ; la clôture leur ajoute 825 PX, reporte la rencontre à la séance suivante et clôt la séance

### Requirement: Clôture d'une table en jalons
En jalons ([S7]), la clôture SHALL demander un motif visible des joueurs et proposer la montée de niveau aux PJ : les présents cochés, les absents décochés, et ceux déjà servis pendant la séance cochés et grisés. La clôture SHALL accorder le niveau suivant aux PJ cochés, avec le motif et la séance (EF-SEA-04).

#### Scenario: [S7]
- **WHEN** Camille écrit « Varga capturée », décoche Mira, garde la rencontre non jouée sans séance et clôt
- **THEN** Aldric reçoit le niveau 6 en jalon avec ce motif, Mira rien, et la rencontre n'a plus de séance
