# Fixtures [D1] : jeu de données de référence

Source : planche `docs/maquettes/texte/D01-Jeu-De-Donnees.txt` (et son PNG). Cahier §12.1.

Chaque fichier `*.json` décrit un personnage :

- `input` : ce qui est **stocké** (cahier §10.3 « grants », §11.2) : valeurs de base, distribution d'Historique, niveaux de classe, dons et leurs choix, bottes, objets. Jamais de valeur calculée.
- `expected` : la fiche que `computeSheet()` doit produire, **écrite à la main** et vérifiée dans `docs/srd/FR_SRD_CC_v5.2.1.txt` (page du SRD citée dans `srd_refs`). Jamais recopiée depuis la sortie du code.
- `expected.sources` : la décomposition attendue (EF-PJ-03) pour les valeurs qui en ont une.

Conventions :

- identifiants de contenu `{namespace}:{type}:{slug}`, slugs anglais stables (cahier §10.3) ;
- distances en **pieds** (stockage, ENF-13) ; la planche affiche des mètres (30 pieds = 9 m) ;
- `"status": "active"` : testé dès M0 ; `"status": "pending_content"` : attend le contenu SRD de M1 (classe absente de l'échantillon M0), test marqué `skip`.

`encounters.json` reprend les rencontres et les PX de la planche (tests de la jauge de difficulté en M3).

Le niveau 1 d'Aldric (`aldric_n1.json`) n'était pas sur la planche : il est **dérivé** du niveau 5 (seule répartition à 27 points compatible avec ses valeurs) et a été ajouté à [D1] le 25 octobre 2026, validé par le porteur de projet.
