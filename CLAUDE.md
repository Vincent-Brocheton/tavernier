# CLAUDE.md — Gestion de personnage compatible 5e

Ce fichier va à la racine du dépôt. Claude Code le relit à chaque session : il résume le projet, les règles de travail et où trouver le détail.

## Le projet en bref

Application **gratuite, multiplateforme et offline-first** d'aide à la maîtrise pour les règles 2024, compatible cinquième édition.

- **MJ** : tables, séances, PNJ, rencontres et combat. Une séance entière doit se jouer **sans réseau**.
- **Joueurs** : création et évolution de leur fiche, avec validation automatique des règles 2024.
- **Homebrew** de tout type, partagé entre MJ par fichier `.dndpack` signé.
- **Contenu de règles** : SRD 5.2.1 **en français officiel** (CC-BY-4.0), et rien d'autre.
- **Comptes** obligatoires pour les tables, à partir de 15 ans. Un seul MJ par table au MVP.
- **Plateformes** : Web d'abord, puis téléphone, puis tablette paysage. Windows et macOS en V1.5. Thème sombre par défaut.

## Où est la vérité (par ordre de priorité)

1. `docs/CAHIER_DES_CHARGES.md` : exigences (EF-…, ENF-…), architecture (§10), modèle de données (§11), tests et CI (§12), user stories (§13), décisions (§14). **En cas de contradiction, le cahier gagne.**
2. Le tableau Trello « Application compatible 5e » : https://trello.com/b/IwARjheH/application-compatible-5e. Il porte le travail à faire, carte par carte (voir « Suivi des tâches » plus bas).
3. `docs/design/COMPOSANTS.md` (58 composants, règles transverses, 40 décisions de design), `docs/design/design_tokens.json` (source de vérité du thème), `docs/design/CONFORMITE.md` (exigence → planche).
4. `docs/maquettes/` : 137 planches. `INDEX.md` pour s'y retrouver, `png/` pour voir, `texte/` pour chercher un libellé, `html/` pour les valeurs exactes.
5. `docs/srd/FR_SRD_CC_v5.2.1.pdf` (et `.txt` pour grep) : **toute règle de jeu se vérifie ici**, jamais de mémoire. En cas de doute entre ta mémoire des règles et le SRD, le SRD gagne.
6. `docs/design/REVUE_MJ.md` : historique des revues (règles corrigées, points joueur), utile pour comprendre le pourquoi.

**Planche [D1] = fixtures.** `docs/maquettes/texte/D01-Jeu-De-Donnees.txt` (et le PNG) fixe les personnages Aldric, Mira, Thalia, Brannoc et Kael, la table « Les Marches de Brumeval », les rencontres et les PX. Les tests du moteur doivent retrouver **exactement** ces valeurs (§12.1). Une maquette, un test ou un calcul qui s'en écarte est un défaut.

## Architecture (cahier §10)

```
packages/
  dnd_rules/      moteur pur Dart : computeSheet(), validations, interpréteur du DSL d'effets
  dnd_content/    modèles et validateurs des entités, format .dndpack
  dnd_data/       Drift : tables, DAO, migrations, import/export, adaptateur de synchronisation
  dnd_ui_kit/     tokens, thèmes, composants partagés
apps/
  game_table/     application Flutter (écrans, go_router, Riverpod)
tools/
  srd_builder/    CLI Dart : sources JSON → pack SRD 5.2.1 (FR)
backend/
  supabase/       schéma Postgres, RLS, migrations, règles de synchronisation PowerSync
```

- **Stack** : Flutter stable et Dart 3 ; Riverpod ; freezed et json_serializable ; Drift/SQLite, avec SQLite WASM sur le Web (OPFS, repli IndexedDB) ; PowerSync + Supabase (région UE) ; go_router ; flutter_localizations + ARB ; Sentry (uniquement après consentement).
- **`computeSheet(personnage, contenu actif) → fiche calculée` est une fonction pure** : ni base, ni réseau, ni Flutter dans `dnd_rules`.
- **Grants** : on stocke les sources (choix, dons, niveaux), pas les valeurs finales. Chaque valeur calculée garde la trace de ses contributions, pour la décomposition au toucher (EF-PJ-03).
- **DSL d'effets** à liste fermée (`ability_bonus`, `grant_proficiency`, `grant_feat`, `grant_spell`, `grant_resource`, `modify_speed`, `modify_ac`, `grant_mastery_slots`, `choice`…). Une opération inconnue rend l'entité invalide. Un pack n'exécute jamais de code.
- **Identifiants** : `{namespace}:{type}:{slug}` pour le contenu (ex. `srd:background:soldier`), UUID v7 pour les données utilisateur.
- **Combat = journal d'événements** : l'état est une projection du journal, ce qui donne l'annulation et la fusion à la synchronisation.
- **Dès M1, toutes les écritures passent par une couche de dépôts unique**, pour que le moteur de synchronisation reste remplaçable.

## Règles de travail

- **Un jalon à la fois** (M0 → M4), carte par carte, dans l'ordre de la liste Trello du jalon. Respecte le critère de sortie du jalon (cahier §3) avant de passer au suivant.
- **Plan avant code** pour chaque carte : fichiers touchés, tests prévus, exigences couvertes. Commence à coder sans attendre validation, sauf si la carte est ambiguë ou touche à une décision irréversible (schéma publié, format `.dndpack`, RLS).
- **Tests d'abord pour `dnd_rules`** : couverture ≥ 95 % des lignes, un test par règle d'intégrité (§11.3). Les valeurs attendues viennent de [D1] ou du SRD, écrites à la main, jamais recopiées depuis la sortie du code.
- **Branches** `feature/<id-carte>-<slug>`, **commits conventionnels** (`feat:`, `fix:`, `test:`, `chore:`…) qui citent la carte et les exigences, par exemple `feat(rules): bonus d'Historique 2-1 / 1-1-1 (US-06, EF-PJ-02)`. Fusion par pull request, CI verte obligatoire.
- **Aucune chaîne d'interface en dur** : tout passe par les ARB, en français. **Aucune valeur de règle en dur dans l'UI** : elle vient de `dnd_rules`.
- **Vocabulaire du SRD français** : « état » (pas « condition »), « profil de jeu », « Amical / Indifférent / Hostile », « Bottes d'armes », « Acquisition par points », « Repos court / Repos long », « Inspiration héroïque ». Distances stockées en pieds, affichées en mètres (1,5 m pour 5 pieds).
- **Interfaces** : suis les planches et `COMPOSANTS.md` à la lettre, avec les tokens de `design_tokens.json` via le thème (jamais de couleur en dur) et des cibles tactiles ≥ 48 dp. La couleur ne porte jamais seule une information : toujours une icône et un libellé.
- **Quand une règle de jeu est floue**, cherche dans `docs/srd/FR_SRD_CC_v5.2.1.txt`. Si le SRD ne tranche pas, demande au porteur de projet au lieu d'inventer.

## Suivi des tâches (Trello)

Le tableau https://trello.com/b/IwARjheH/application-compatible-5e est la seule liste de travail ; aucune copie des cartes n'est gardée dans le dépôt.

- **Listes** : « Backlog M0 — Fondations », « Backlog M1 — Personnages hors-ligne », « Backlog M2 — Comptes, tables, synchronisation », « Backlog M3 — Gestion de table », « Backlog M4 — Homebrew », « Plus tard — V1.5 et V2 », « Fait ».
- **Cartes** : `US-xx` pour une user story (reprise du cahier §13), `T-xx` pour une tâche technique. Chaque carte cite les exigences (EF-…, ENF-…) et les sections du cahier concernées. Le détail fonctionnel est dans le cahier, pas sur la carte.
- **Cycle** : une carte est prise dans la liste de son jalon, développée sur sa branche `feature/<id-carte>-<slug>`, puis passée dans « Fait » quand sa pull request est fusionnée. Une question ou un écart se note en commentaire sur la carte.
- **Accès** : si le connecteur Trello est disponible, lis les cartes et mets-les à jour toi-même (commentaire à l'ouverture de la PR, carte passée dans « Fait » à la fusion). Sinon, demande au porteur de projet la liste des cartes du jalon en cours, et signale-lui en fin de carte ce qu'il doit déplacer.
- **Ne pas toucher** aux cartes de « Plus tard » sans demande explicite.

## Interdits (légal, cahier §1.3)

- **Aucun contenu du Player's Handbook hors SRD** : ni texte, ni sous-classe, ni sort, ni monstre absent du SRD 5.2.1.
- **Pas de marque** : jamais « D&D », « Dungeons & Dragons », logo ou motif de la marque dans le code visible, les noms, l'icône ou les stores. Seules mentions permises : « compatible 5E » ou « compatible avec la cinquième édition ».
- **Attribution CC-BY** : la déclaration officielle du SRD est reproduite mot pour mot dans « À propos », dans le manifeste du pack SRD et dans les stores (texte exact en §1.3 du cahier).
- **Pas de traduction maison** du contenu de règles : le texte vient du PDF français officiel.
- **Données personnelles** : hébergement UE, aucune analytique d'usage, rapports de crash seulement avec consentement et sans données de jeu.

## Décisions à ne pas rediscuter (extraits, liste complète en cahier §14.2 et dans COMPOSANTS.md §4)

- **PowerSync** retenu, intégré en M2, cible Web d'abord.
- **Jets** : jet simple au MVP (« Saisir mon jet » et « Lancer »). Pas de lanceur libre ni d'historique avant la V2.
- **Égalités d'initiative** (SRD) : le MJ ordonne les monstres, les joueurs leurs PJ, le MJ tranche entre monstre et PJ. L'ordre par défaut n'est qu'une commodité.
- **Progression** en PX ou en jalons, choisie par table. En jalons, aucun PX n'est affiché aux joueurs.
- **MJ qui supprime son compte** : la table continue d'exister sans MJ ; ses fiches passent en lecture seule ; pas de transfert de MJ ; un joueur ne peut pas en retirer son PJ.
- **Conflits** : sur les fiches, dernier écrit gagnant champ par champ ; en combat, le MJ prime. Tout écrasement d'une donnée joueur est notifié.

## Commandes

À compléter dans US-01 dès que le monorepo existe. Prévu :

```
melos bootstrap
melos run analyze        # flutter analyze, lints stricts
melos run test           # tests unitaires et de widgets
melos run coverage       # couverture (dnd_rules ≥ 95 %)
dart format --set-exit-if-changed .
dart run tools/srd_builder/bin/srd_builder.dart build   # pack SRD
```

## Manques connus du pack de départ

- `app_theme.dart` et `pubspec_extrait.yaml`, cités par `COMPOSANTS.md`, ne sont pas fournis : ils sont à produire dans T-07 à partir de `design_tokens.json`.
- Le schéma d'architecture du cahier §10 était une image : il n'apparaît pas dans l'export Markdown. Le texte du §10 suffit.
- Les PNG des maquettes sont rendus avec des polices de repli. Les vraies polices (Cinzel pour les titres, Roboto Flex pour le reste, chiffres tabulaires) sont décrites dans les tokens.
