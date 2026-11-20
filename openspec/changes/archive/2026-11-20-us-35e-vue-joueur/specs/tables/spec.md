## ADDED Requirements

### Requirement: Séance close vue par le joueur
Pour une séance close, le joueur SHALL voir les gains de ses seuls PJ :
- en PX : les PX gagnés et la progression vers le niveau suivant ;
- en jalons : le niveau accordé et son motif, sans aucun PX (EF-TAB-10).

La séance SHALL s'ouvrir sur ces gains et sur les notes de la séance, les siennes et celles partagées. Le résumé des rencontres n'y figure pas (EF-SEA-07, [S5]).

#### Scenario: [S5]
- **WHEN** Hugo regarde la séance 12, close, où Aldric et Mira ont gagné 825 PX
- **THEN** il lit « +825 PX pour Aldric Varenne » et « 825 / 14 000 PX · niveau 6 à 14 000 », rien pour Mira, et la séance s'ouvre sur la note partagée par Camille, sans sa note privée

#### Scenario: En jalons
- **WHEN** Aldric reçoit le niveau 6 pour « Varga capturée »
- **THEN** Hugo lit « Niveau 6 accordé à Aldric Varenne » et le motif, sans aucun PX
