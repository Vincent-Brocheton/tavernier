# Passation design → développement

> **Note de mise à jour (25 octobre 2026, pack Claude Code)** : la question ouverte n° 1 (transfert de table) est tranchée. Si le MJ supprime son compte, la table continue d'exister sans MJ, ses fiches passent en lecture seule, sans transfert de MJ au MVP, et un joueur ne peut pas en retirer son PJ. Voir cahier §14.3. Les fichiers `app_theme.dart` et `pubspec_extrait.yaml` cités ci-dessous ne sont pas dans ce pack : ils sont à produire dans la carte T-07 à partir de `design_tokens.json`.


**Gestion de personnage compatible 5E** · Material 3 · Flutter 3.47+ (`material_ui`)
Maquettes de référence : https://claude.ai/artifact/86d32GRYa7h2pXc9FvNmW8 (12 pages, 137 planches). Les identifiants entre crochets, par exemple [C3], renvoient aux titres des écrans sur la planche.

**Données de test** : la planche [D1] « Jeu de données de référence » (page Revue MJ) fixe les personnages, rencontres et séances utilisés sur toutes les maquettes. Elle sert de fixtures aux tests du moteur de règles (§12.1 du cahier).

Fichiers fournis :

| Fichier | Rôle |
|---|---|
| `design_tokens.json` | Source de vérité : couleurs sombre et clair, sémantiques, typo, espacements, rayons, tailles, points de rupture, états, mouvement |
| `app_theme.dart` | `AppTheme.dark` / `AppTheme.light`, extension `GameColors`, constantes `AppSpacing`, `AppRadii`, `AppSizes`, `formFactorOf()` |
| `pubspec_extrait.yaml` | Contraintes SDK, dépendance `material_ui`, polices embarquées |
| `COMPOSANTS.md` | Ce document : règles, inventaire des composants, états, accessibilité |
| `CONFORMITE.md` | Correspondance exigence par exigence entre le cahier des charges et les planches |

`app_theme.dart` cible Flutter 3.47+ / Dart 3.13+ et importe `package:material_ui/material_ui.dart`. Il n’a pas été compilé dans cet environnement : à valider avec `flutter analyze`.

---

## 1. Règles transverses

### Langage visuel

- **Thème sombre par défaut** au MVP (`themeMode: ThemeMode.dark`). Thème clair déjà dans les tokens, livré en V1.5.
- **Une seule couleur d’accent** : `primary` vert-de-gris. Le doré `tertiary` est réservé aux titres en Cinzel et au homebrew.
- **Cinq couleurs sémantiques réservées** (`GameColors`) : dégâts, soins, PV temporaires, concentration, alerte. Elles ne servent à rien d’autre.
- **La couleur ne porte jamais seule une information** : toujours une icône et un libellé (états, jets contre la mort, difficulté, synchronisation).
- **Cinzel uniquement en Display et Headline** (titres d’écran évocateurs, nom de personnage, nom de table). Tout le reste en Roboto Flex.
- **Chiffres tabulaires** (`style.numeric`) pour PV, CA, initiative, DD, PX, compteurs, coûts.
- **Grain** (bruit fractal, opacité 0,07 ; 0,16 sur couverture colorée) uniquement sur en-têtes et cartes de table. Jamais sur une zone de données.
- **Élévation tonale** : les niveaux de surface passent par `surfaceContainer*`, sans ombre ni `surfaceTint`. Les ombres sont réservées au FAB et aux infobulles.
- **Interdits** : aucun nom, logo ou motif rappelant la marque D&D ; aucun visuel du Player’s Handbook. Fournisseurs de connexion en texte seul.

### Ton par écran

- **Écrans de travail** (combat, fiche, compendium, éditeurs) : sobres et denses, sans grain dans les zones de données.
- **Écrans évocateurs** (accueil, table, création, montée de niveau, fin de rencontre) : en-tête à grain et titre en Cinzel.

### Disposition par point de rupture

| Format | Largeur | Navigation | Disposition |
|---|---|---|---|
| Téléphone | < 600 | `NavigationBar` 80 dp, 5 destinations | Une colonne, actions de combat dans le tiers inférieur, feuilles modales |
| Tablette paysage | 600 à 1023 | `NavigationRail` | Deux panneaux : liste + détail ([TB1]–[TB3], 960 × 600) |
| Web desktop | ≥ 1024 | `NavigationRail` 80 dp | Multi-panneaux. Combat : initiative · détail · journal [1c] |

Les 5 destinations sont Accueil, Tables, Personnages, Compendium et Homebrew.

Tablette paysage, règle de passage du desktop à deux panneaux :
- **Combat** [TB1] : ordre d’initiative à gauche (360 dp, cartes réduites à une ligne : initiative, nom, icônes d’état, PV, CA) ; à droite le détail du combattant sélectionné, avec le journal dans un onglet du même panneau. Actions Dégâts / Soins / PV temp. en bas du panneau, à portée de pouce. « Tour suivant » et « Annuler » en tête de liste.
- **Fiche** [TB2] : l’onglet Principal devient un panneau de résumé permanent à gauche (320 dp : PV et actions, valeurs de combat, caractéristiques) ; les autres onglets occupent la droite, contenu sur deux colonnes.
- **Création** [TB3] : étapes à gauche (232 dp) ; à droite, l’acquisition par points et le bonus d’Historique fusionnés dans un seul tableau (base avec −/+, +2, +1, total), aperçu réduit à une ligne en pied d’écran.
- Cibles tactiles de 48 dp maintenues ; les listes plus longues que l’écran défilent dans leur panneau, pas la page.

Marge de page : 16 dp sur téléphone, 24 sur tablette, 32 sur desktop (`AppSpacing.page`). Toutes les pages desktop passent à une colonne sous 600 dp, sans défilement horizontal.

### Accessibilité (ENF-14)

- Cibles tactiles ≥ 48 dp (`MaterialTapTargetSize.padded`). Les puces non interactives dans une carte font 26 dp : la carte entière est la cible.
- Contraste AA vérifié pour toutes les paires texte/fond des tokens. Exception : `outline` en clair, réservé aux bordures (3:1).
- Taille de texte de 85 à 200 % : aucune hauteur fixe sur un conteneur de texte, les lignes passent à la ligne.
- Lecteurs d’écran : chaque composant ci-dessous donne son libellé `Semantics`. Les icônes décoratives sont exclues (`excludeSemantics`).
- Réduction des animations : `MediaQuery.disableAnimations` coupe le squelette pulsé et les transitions emphasized.

### Vocabulaire (SRD 5.2.1 français)

« état » (pas condition), « profil de jeu », « Amical / Indifférent / Hostile », « Bottes d’armes », « Acquisition par points », « Valeurs standard », « Génération aléatoire », « langues courantes », « Repos court / Repos long », « Inspiration héroïque ». Distances en mètres (1,50 m par case).

---

## 2. Inventaire des composants

Pour chaque composant : rôle, anatomie, variantes et états, tokens, sémantique, écrans de référence.

### 2.1 Carte de combattant · `CombatantCard`
**Rôle** : ligne de l’ordre d’initiative, sur téléphone et desktop.
**Anatomie** : pastille d’initiative 40 dp · nom (titleMedium) + sous-titre (bodySmall : type, FP ou classe) · CA (icône bouclier + nombre) · barre de PV (`HpBar`) + « PV / max » + pastille PV temporaires · rangée de puces d’état · jets contre la mort si 0 PV.
**Variantes et états** :

| État | Rendu |
|---|---|
| Standard | `surfaceContainer` |
| Actif (son tour) | `primaryContainer`, liseré 2 dp `primary`, pastille d’initiative `primary`, badge « En cours » |
| Sélectionné (cible) | coche `primary` à droite ; desktop : liseré `secondary` |
| Concentré | puce `concentrationContainer` « Concentration · <sort> » |
| Sous plusieurs états | puces sur plusieurs lignes, sans troncature |
| PJ à 0 PV | liseré `damage`, puce « Inconscient » `damageContainer`, `DeathSaves` |
| Monstre hors de combat | opacité 0,55, `surfaceContainerLow`, sous-titre « Hors de combat », conservé dans la liste |
| Groupe à initiative commune | en-tête de groupe 28 dp avant les membres |

**Densité** : padding 10–12 dp ; desktop avec poignée de glisser-déposer (réordonnancement manuel, égalités).
**Interactions** : toucher pour cibler ; appui long pour la multi-sélection ; glisser sur desktop.
**Sémantique** : « Chef de bande, initiative 18, classe d’armure 15, 31 points de vie sur 52, empoisonné 1 round, tour en cours ».
**Écrans** : [0] Fondations, [1a], [1c], [C3].

### 2.2 Barre de PV · `HpBar`
Piste `surfaceContainerHighest` de 8 dp (6 dp sur desktop). Remplissage `GameColors.hpBar()` : plus de 50 % → soins, plus de 25 % → alerte, sinon dégâts. Toujours accompagnée des chiffres côté MJ. **Côté joueur, pour les autres PJ** : pas de chiffres, état qualitatif icône + libellé (Indemne / Blessé / Gravement blessé, EF-TAB-09) [T13]. Aperçu de dégâts : portion perdue hachurée [1b].

### 2.3 Puce d’état avec durée · `ConditionChip`
Icône 16 à 18 dp + libellé + durée en `numeric` atténuée. Interactive : 32 dp ; non interactive dans une carte : 26 dp. Rayon `sm`. Durées : « 2 rounds », « fin du tour de Mira », « JS FOR DD 13 », « indéfinie ». Au toucher : feuille de règle [K4] ou infobulle riche sur desktop.
**Jeu d’icônes** : 15 états + 13 types de dégâts + action / action Bonus / réaction, tous en trait 24 dp ([0] Fondations). À produire en `IconData` personnalisée (police d’icônes ou SVG via `flutter_svg`).

### 2.4 Pavé dégâts et soins · `DamageKeypad`
Feuille modale (rayon 28, poignée). Cibles en puces d’entrée · valeur en displayLarge couleur dégâts · types de dégâts en puces de filtre défilantes (choix unique) · aperçu par cible (avant → après, hachures, avertissement de concentration avec DD) · pavé 4×4 de touches de 52 dp (×2, ½, PV temp., Soins, +, −) · bouton principal 56 dp « Appliquer 12 dégâts tranchants ».
Règle d’interaction : une action courante tient en deux interactions, sans compter la saisie du nombre. [1b], desktop en ligne [1c].

### 2.5 Alerte de concentration · `ConcentrationPrompt`
Carte `concentrationContainer` : icône, « JS de Constitution DD 10 », explication du DD (10 ou la moitié des dégâts, plafond 30), boutons Échec (contour) / Réussite (plein `concentration`). En cas d’échec : confirmation et retrait des effets liés (EF-CON-05). [1c]

### 2.6 Rappel de tour · `TurnReminder`
Bandeau d’alerte en haut de l’écran de combat sur téléphone [1a], ou dialogue de fin de tour [C6]. Sauvegardes à refaire (Lancer / Échec / Réussite), états qui expirent (« Retiré »), dégâts récurrents. Bouton « Tour suivant : <nom> ».

### 2.7 Jets contre la mort · `DeathSaves`
Trois réussites (cercles, coche, `heal`) et trois échecs (carrés, croix, `damage`) : forme et icône en plus de la couleur. Version compacte dans la carte, version joueur pleine taille avec rappel de règle [C7].

### 2.8 Décomposition d’une valeur · `ValueBreakdown`
Chaque valeur calculée est touchable (EF-PJ-03). Téléphone : feuille modale [2b]. Desktop : infobulle riche ancrée [2c]. Lignes : montant en `numeric` + libellé + sous-libellé + badge de source. Total et règle de calcul. « Utilisée par » en puces. Encart « ajustement manuel » (dérogation MJ tracée).

### 2.9 Répartition des bonus d’Historique · `BackgroundBonusPicker`
Segmenté « +2 et +1 » / « +1, +1 et +1 ». Tableau des 6 caractéristiques : base, +2, +1 (bascules 64×48), règle, total + modificateur. Non éligible : cadenas et bascule en pointillés désactivée. Même ligne pour +2 et +1 : désactivé avec explication. Plafond 20. Choix devenu invalide : bandeau `errorContainer` qui explique la règle, bascule barrée [3a]. Interactif [3b].

### 2.10 Acquisition par points · `PointBuyStepper`
Budget en barre de progression + « 27 / 27 ». Tuile par caractéristique : coût, boutons −/+ de 40 dp, valeur. + désactivé si le budget est dépassé ou si la valeur atteint 15. [3b]

### 2.11 Choix bloqué et expliqué · `BlockedOption` (motif)
Toute option impossible reste visible : opacité 0,6, cadenas ou bordure en pointillés, sous-libellé `error` qui donne la règle. Exemples : « Déjà obtenu par l’Historique Soldat · non répétable », « Déjà maîtrisée (Soldat) ». [P5], [P11], [P10].

### 2.12 Jauge de difficulté · `DifficultyGauge`
Barre 16 dp avec repères verticaux Faible / Modérée / Élevée (budget 2024 × PJ présents) et libellés en dessous. Remplissage : sous Faible `outline`, Faible soins, Modérée alerte, Élevée et au-delà dégâts. Libellé et icône de difficulté à gauche, total PX à droite. Mise à jour à chaque ajout (`aria-live` → `Semantics(liveRegion: true)`). [C1], version compacte [T9].

### 2.13 Badge de source · `SourceBadge`
Hauteur 22 à 26 dp, rayon 6. SRD : `surfaceContainerHighest`. Homebrew : `tertiaryContainer` + nom du pack + version. Variante alerte « Contenu modifié · v1.4 dispo ». [0], [K1], [H1].

### 2.14 Indicateur de synchronisation · `SyncIndicator`
Pilule 32 dp ou icône seule dans la barre supérieure. 4 états : Synchronisé (nuage coché, soins), En attente (nuage flèche, PV temp + nombre), Hors-ligne (nuage barré, neutre, « tout reste disponible »), Conflit résolu (triangle, alerte, lien vers le détail). Jamais bloquant. [0], [1a], [T7].

### 2.15 Tuiles de valeur · `AbilityTile`, `StatTile`
Caractéristique : abréviation, modificateur en grand, valeur en pastille, JS avec point de maîtrise. Statistique : valeur + libellé (CA, Initiative, Vitesse, Maîtrise, Perception passive, Inspiration). Toutes touchables vers `ValueBreakdown`. [2a], [2c].

### 2.16 Pips de ressource · `ResourcePips`
Cercles 16 à 18 dp (plein = disponible). Carrés pour les ressources « par jour ». Libellé `Semantics` : « 2 utilisations sur 3 ». Emplacements de sort, Second souffle, dés de vie, actions et résistances légendaires (boutons 44 dp sur desktop) [C8].

### 2.17 Bandeau d’état · `StatusBanner`
Carte rayon 12 en haut de contenu. Variantes : alerte (`alertContainer`), erreur de règle (`errorContainer`), hors-ligne (`surfaceContainerHigh`, nuage barré), conflit résolu (`alertContainer` + « Voir l’historique » / « OK »), information (`primaryContainer`).

### 2.18 Assistant par étapes · `WizardSteps`
Desktop : liste verticale de 9 étapes (pastille cochée, courante ou numéro + sous-libellé du choix fait ; point d’alerte si une étape a une alerte). Téléphone : « Étape n sur 9 » + barre de progression 4 dp. Pied d’écran : Précédent (contour) / Suivant (plein, désactivé avec raison au-dessus). [P1]–[P9].

### 2.19 Entrée de journal · `LogEntry`
Pastille d’icône colorée par catégorie + texte + « R3 · 21:42 » en `numeric` + bouton annuler sur la dernière entrée (au moins 20 actions annulables). Filtres en puces. [1c].

### 2.20 Phrase d’effet · `EffectSentence`
Effet homebrew écrit comme une phrase : mots fixes (`onSurfaceVariant`) + listes déroulantes en puces `secondaryContainer` + valeurs avec −/+. Paramètre manquant : puce en pointillés `error`. Liste fermée d’opérations à gauche, aperçu du texte joueur à droite. [H3].

### 2.21 Palier d’information · `InfoTierRow`
Badge « DD 15 » + texte + statut (œil = révélée, cadenas = cachée). Dans l’assistant Étude, les paliers atteints passent en `healContainer`. [C2], [C9].

### 2.22 Invitation · `InviteCode`
QR sur fond `onSurface` (quiet zone), code à 6 caractères en `numeric` espacé, copier / partager, expiration, révoquer (`error`). Saisie côté joueur : 6 cases de 56 dp. [T10], [T11], [T12].

### 2.23 En-tête texturé · `TexturedHeader`
`surfaceContainerLow` (ou couleur de couverture de table) + grain + surtitre en labelMedium majuscules + titre en Cinzel + description. [P1], [T9], [C11].

### 2.24 Entrée d’historique · `HistoryEntry`
Heure en `numeric` + pastille d’icône par catégorie (Combat `damageContainer`, Soin `healContainer`, Progression `primaryContainer`, Dérogation MJ `alertContainer`, Repos et Synchronisation `surfaceContainerHighest`, Homebrew `tertiaryContainer`) + texte + « auteur · catégorie » + écart chiffré à droite. Badges : « Non notifiée », « Conflit résolu », « Remplacé » (texte barré), « En attente de synchronisation » (`tempHpContainer`), « Acceptée ». Détail : qui, quand, où, tableau avant → après, motif du MJ s’il y a lieu. Lecture seule. Desktop : liste + panneau de détail ; téléphone : entrée dépliable. Filtres par catégorie (compteurs, désactivé à 0) et par auteur (segmenté). [N1], [N2].

### 2.25 Éditeur de note · `NoteEditor`
Puce de rattachement (table, séance, PNJ ou rencontre), titre, barre d’outils réduite (gras, listes, lien), liens internes en puces `primaryContainer` cliquables. Saisie de `[[` ou bouton Lien → feuille « Insérer un lien » limitée aux PNJ et rencontres visibles par l’auteur. Pied : interrupteur de visibilité (privée par défaut), pour le MJ comme pour le joueur. Une note partagée par quelqu’un d’autre s’ouvre en lecture seule, sans barre d’outils. État d’enregistrement discret dans l’en-tête (hors-ligne, en attente, synchronisée). [N3], [N5].

### 2.26 Résultat de recherche de note · `NoteSearchHit`
Titre + extrait centré sur l’occurrence, surlignée en `tertiaryContainer` + puce de rattachement + badge « Partagée par … » (MJ ou joueur). Recherche locale, sans accents ni casse ; compteur « n résultats · recherche hors-ligne dans N notes ». [N3], [N6].

### 2.27 Carte de séance · `SessionCard`
Pavé date (mois en labelSmall, jour en `numeric`) + « Séance n » + titre + sous-ligne (rencontres, PX) + badge d’état : Préparée (`healContainer`), En cours, Close (`surfaceContainerHighest`). Sélectionnée : contour `primary`. [S1], [S5].

### 2.28 Prêt hors-ligne · `OfflineReadiness`
Liste de vérifications de ce qu’il faut pour jouer sans réseau : rencontres et blocs de stats, PNJ, notes, fiches à jour. Coche `heal` ; élément en attente de synchronisation : horloge `tempHp` + explication de la version utilisée à défaut. [S2].

### 2.29 Tableau de PX de séance · `SessionXpTable`
Une ligne par personnage : PX par rencontre, total de la séance en `heal`, barre de progression vers le seuil suivant (partie acquise atténuée, gain de la séance plein). Personnage absent : ligne à 60 % d’opacité, « — ». [S4]. En table à jalons, remplacé par `MilestonePicker` : interrupteur « Jalon atteint », motif visible des joueurs, case à cocher par personnage avec « niveau n → n+1 » (absents décochés par défaut). [S7]. Le même sélecteur s’ouvre en cours de séance depuis « Accorder un niveau » ([S8]) ; à la clôture, les personnages déjà servis apparaissent cochés et grisés.

### 2.30 Niveau accordé · `LevelGrantBanner`
En tête de l’onglet Principal de la fiche, `primaryContainer` : « Niveau n accordé par … », motif du jalon, boutons « Plus tard » (texte) et « Monter au niveau n » (plein, ouvre l’assistant de montée de niveau). Après « Plus tard », se réduit en puce dans le bloc d’identité jusqu’à la montée. [S9].

### 2.31 Gabarit d’éditeur de contenu · `EntityEditorScaffold`
Desktop : en-tête (pack · version · état, type d’entité, « Enregistré sur l’appareil », Tester, Enregistrer désactivé tant qu’une erreur bloque), arbre du pack à gauche (pastille d’erreur par entité), formulaire en sections au centre, panneau Vérification et aperçu à droite. Téléphone : une colonne, Tester / Enregistrer en pied. Les champs calculés (bonus de maîtrise, PX d’un FP, PV moyens) portent un cadenas et ne se saisissent pas. [E3]–[E8], [H2], [H5].

### 2.32 Sélecteur de type d’entité · `EntityTypePicker`
Dialogue : segmenté « Partir de zéro / Dériver d’une entité du SRD », grille de 8 cartes (icône, nom, contrainte 2024 en une ligne, nombre déjà présent dans le pack). [E1]. La dérivation ouvre une recherche hors-ligne dans le SRD, un nom de variante et le pack de destination ; le SRD n’est jamais modifié. [E2].

### 2.33 Tableau de progression de classe · `ClassProgressionTable`
20 lignes : niveau, bonus de maîtrise (calculé), aptitudes, nombre de bottes, action. Ligne en erreur : fond `errorContainer` + filet gauche `error` + règle sous l’aptitude ; ligne vide : « Vide » en italique et bouton Ajouter. Compteur « n niveaux sur 20 renseignés ». [E3].

### 2.34 Compteur de sélection imposée · `ExactCountChips`
Puces à cocher avec compteur « n / attendu » ; au maximum, les autres puces passent en pointillés désactivés ; au-delà (cas d’import ou de dérivation), badge `errorContainer` et alerte avec une action par puce à retirer. [E3] jets de sauvegarde, [E6] caractéristiques et compétences.

### 2.35 Ligne d’attaque · `AttackRow`
Nom de l’arme, type de dégâts et propriétés, deux tuiles chiffrées (toucher, dégâts) en `numeric`, badge de botte `primaryContainer`, rappel de critique si une aptitude le modifie. [F1].

### 2.36 Compteur d’utilisations · `UsesCounter`
Pastilles pleines / vides (`ResourcePips`), règle de récupération en légende (« repos court : +1 »), bouton Utiliser tonal. Même composant dans l’onglet Combat et dans l’onglet Aptitudes, groupé par origine (classe, sous-classe, espèce, dons) avec badge de source. [F1], [F2].

### 2.37 Vue combat du joueur · `PlayerCombatView`
Écran téléphone qui remplace la fiche quand le MJ lance une rencontre où figure le PJ ; retour à la fiche complète en un geste. En haut, le `TurnBanner` (2.38). Puis l’ordre d’initiative simplifié : PJ avec état de santé qualitatif, adversaires rendus visibles sous leur seul nom (ni PV ni CA), adversaires cachés absents, ni journal ni Étude. Puis le personnage : PV, PV temporaires, boutons Dégâts / Soins / PV temp., états avec durée, concentration, réaction. Enfin les actions rapides : attaques (`AttackRow`) et sorts préparés avec emplacements. Hors-ligne : dernier état connu et « Hors-ligne : dites vos changements au MJ ». Une modification du joueur remonte au journal du MJ ; à conflit, la version du MJ prime. [J1], [J2], [J3]

### 2.38 Bandeau de tour · `TurnBanner`
« Round 3 · Tour du Chef de bande · vous jouez dans 2 tours » en `surfaceContainerHigh` ; à son tour, `primaryContainer` « C’est votre tour » avec quatre cases à cocher : action, action Bonus, réaction, déplacement. Annoncé en région live polie. [J1], [J2]

### 2.39 Effets reçus · `ReceivedEffectsBlock`
Liste des effets posés par d’autres : nom, source, durée restante, effet en une ligne (« Béni · de Mira · +1d4 aux attaques et aux JS · 8 rounds »). Les états négatifs ont le même traitement avec la couleur d’alerte. Chaque valeur touchée cite l’effet dans sa `ValueBreakdown` (« +1d4 Béni (Mira) »). L’effet disparaît à expiration ou à la fin de la concentration du lanceur. Sur l’onglet Principal et dans la vue combat. [J4]

### 2.40 Demande de jet · `RollRequestSheet`
Feuille modale envoyée par le MJ au joueur concerné : type de jet, DD, bonus du personnage, et les deux chemins du `SimpleRoll` (2.41). Le résultat remonte chez le MJ, qui peut saisir à la place du joueur hors-ligne. Concentration, sauvegarde à refaire, jet contre la mort. [J5]

### 2.41 Jet simple · `SimpleRoll`
Deux boutons côte à côte, « Saisir mon jet » et « Lancer ». Le lancer connaît sa formule : dés, bonus, Avantage ou Désavantage (deux d20, le dé écarté barré) et effets reçus (+1d4 Béni). Le résultat s’affiche décomposé (« d20 8 + Béni 1d4 (3) = 11 ») et reste modifiable avant validation. Paramètre `die` (d20, 2d4 + 2, d10…). Pas de lanceur libre ni d’historique au MVP. [J6], [J7], [C4], [C7], [P12]

### 2.42 Aperçu des automatismes à 0 PV · `ZeroHpPreview`
Bloc sous le `DamageKeypad` qui annonce, avant validation, la conséquence de règle : mort sur le coup (« excédent 27 ≥ PV max 27 »), tomber Inconscient, échec(s) de jet contre la mort (deux si « Coup critique »), Stabilisé remis aux jets. Couleur de dégâts + icône, bouton « Valider quand même » et annulation au journal. L’option « Assommer » (1 PV, Inconscient) s’affiche quand une attaque au corps à corps ferait tomber une créature à 0 PV. [F2a], [F2b], [F2c]

### 2.43 Puce d’épuisement · `ExhaustionChip`
« Épuisement 2 · −4 aux tests d20 · Vitesse −3 m » sur la carte de combattant et en tête de fiche. Chaque valeur touchée montre la ligne « −4 Épuisement (niveau 2) ». Le passage au niveau 6 ouvre une confirmation explicite qui marque le personnage mort. [F3a], [F3b]

### 2.44 Proposition structurelle · `ProposalBanner`
Côté MJ : l’assistant concerné en mode proposition, motif obligatoire. Côté joueur : encadré en tête de fiche, même gabarit que `LevelGrantBanner`, « Camille propose : remplacer le don Vigilant par Doué · Motif : … », aperçu avant / après des valeurs touchées, « Refuser » (avec message) et « Accepter ». L’acceptation est tracée dans l’historique. [F4a], [F4b]

### 2.45 Magie de pacte · `PactMagicBlock`
Bloc séparé des emplacements de sort : n emplacements tous du même niveau (« 2 emplacements du 3e niveau »), récupérés au repos court, `ResourcePips` dédiés. Un sort d’Occultiste se lance au niveau du pacte, sans choix de niveau. [F5a]

### 2.46 Emplacements de multiclassage · `MulticlassSlotTable`
Niveau de lanceur de sorts calculé, décomposé au toucher (« Clerc 3 + Paladin 4 ÷ 2 (arrondi supérieur) = 5 »), table d’emplacements combinée, sorts préparés groupés par classe avec leur caractéristique et leur DD. La magie de pacte reste à part. [F5b]

### 2.47 Utilisation d’un consommable · `ConsumableUseSheet`
Bouton « Utiliser » sur un consommable : coût d’action rappelé (« action Bonus »), `SimpleRoll` du soin (2d4 + 2), aperçu des PV (34 → 41), quantité décomptée, entrée d’historique. [J7]

### 2.48 Inspiration héroïque · `HeroicInspirationControl`
« Utiliser » (relancer un dé, garder le nouveau) ; quand le personnage en reçoit une alors qu’il en a déjà une, « Donner à… » liste les PJ qui n’en ont pas. [J8]

### 2.49 Repos de groupe · `GroupRestPanel`
MJ : choix du repos, PJ présents cochés, suivi « a terminé / en cours » par joueur. Joueur : l’écran de repos habituel ([P12] ou [P13]) ouvert par la demande, avec l’origine en tête. Le repos individuel reste possible hors séance. [J9], [J10]

### 2.50 Suggestion · `SuggestionCard`
Bouton « Suggérer » à chaque étape de création et de montée de niveau : choix prérempli, modifiable, avec sa raison en une ligne. Jamais appliqué sans geste du joueur. [J11]

### 2.51 Fiche en attente, jouable · `PendingPlayableBanner`
« En attente de validation par Camille · utilisable en jeu ». La fiche reste jouable ; des corrections demandées s’appliquent après la séance sans perdre l’état de jeu. [J12]

### 2.52 Terme de règle · `RuleTermLink`
Terme souligné en pointillé dans les aptitudes, sorts et effets ; un toucher ouvre sa fiche du compendium en feuille modale, sans quitter la fiche. Rôle lien, libellé « Désavantage, définition ». [J13]

### 2.53 Origine de la montée de niveau · `LevelUpOrigin`
Le bouton « Monter de niveau » dit toujours d’où il vient : « Seuil de 14 000 PX atteint », « Niveau 6 accordé par Camille · motif », « … (dérogation) ». Sinon l’en-tête montre la progression (`role="meter"`, « 7 475 / 14 000 PX ») ou « Prochain jalon : décidé par le MJ ». [D2], [2c]

### 2.54 Badge d’égalité d’initiative · `InitiativeTieBadge`
« Égalité · le MJ décide » ou « Égalité · Hugo et Léo décident ». L’ordre par défaut (bonus d’initiative) est présenté comme une commodité, jamais comme une règle ; les joueurs concernés réordonnent depuis leur téléphone, ou le MJ pour eux. [C3]

### 2.55 Échange d’initiative (Vigilant) · `InitiativeSwapAction`
Encadré sous l’ordre du tour pour un PJ qui a le don Vigilant : rappel de la règle (allié consentant, juste après le jet, impossible si l’un des deux est Neutralisé) et bouton « Échanger avec… », qui ouvre la liste des alliés éligibles. Le joueur peut aussi le faire depuis son téléphone. [C3] (EF-INI-09)

### 2.56 Puce de réaction · `ReactionChip`
« Réaction disponible » (contour) ou « Réaction utilisée » (remplie), icône éclair + libellé, sur la carte de chaque PJ comme pour les monstres ; réinitialisée au début de son tour. [1c], [J1] (EF-INI-08)

### 2.57 Méthode de connexion · `SignInMethodRow`
Icône, nom (Mot de passe, Google, Apple), adresse ou « Non liée », badge « Active », action « Lier », « Ajouter » ou « Retirer ». « Retirer » est désactivé sur la dernière méthode restante. [A6], [A7]

### 2.58 Règles du mot de passe · `PasswordRules`
Jauge de robustesse en 4 segments (`role="meter"`, libellé texte) et liste de règles cochées au fil de la saisie, chacune avec son état lu par le lecteur d’écran. [A3], [A5]

---

## 3. États à couvrir (§9.5) : où les trouver

| État | Écrans de référence |
|---|---|
| Vide, premier usage, action suggérée | [T4] accueil, [P17] sorts d’un Guerrier, [K5] aucun résultat, [N7] notes, [S6] séances |
| Chargement | [P18] squelette (pulsation coupée si animations réduites) |
| Hors-ligne | [P7], [T12], [K2], [1a], [N2], [N5], [S3] séance en cours, [S4] clôture, [J3] combat joueur, [A4] première connexion |
| Synchronisation en attente | [P9] suivi d’envoi, [T7] accueil, [N2], [N4], [S2] fiche d’un joueur |
| Conflit résolu | [P16] fiche joueur, [T9] activité MJ, [N1] historique, [N3] note modifiée sur deux appareils |
| Erreur de saisie (compte) | [T2] âge, [A1] identifiants |
| Erreur de règle expliquée | [3a], [P5], [P10], [P11], [H2], [H5], [T2], [E3]–[E8] (une règle 2024 par type d’entité) |
| Combat : actif, 0 PV, concentré, plusieurs états | [0] Fondations, [1a], [1c], [F2a]–[F2c] automatismes, [F3a] épuisement |
| Combat vu du joueur : pas son tour, son tour, hors-ligne | [J1], [J2], [J3] |
| Demande reçue du MJ (jet, repos, proposition, niveau) | [J5], [J10], [F4b], [S9] |
| Fiche en attente de validation, jouable | [J12] |

---

## 4. Décisions prises pendant le design

Toutes reportées dans le cahier mis à jour le 25 octobre 2026 (§14.2) :

1. **Tables d’un MJ supprimé** : elles restent en place pour leurs joueurs, sans MJ. (Décision du porteur de projet.)
2. **Dérogations au rattachement** : pas de notification au joueur, seulement une ligne dans l’historique de la fiche. (Décision du porteur de projet.)
3. **Alertes du récapitulatif** : elles ne bloquent pas l’envoi au MJ. Seules les erreurs de règle bloquent « Suivant ».
4. **Rejoindre hors-ligne** : la demande est mise en file au lieu d’échouer.
5. **Montée de niveau en table** : tracée dans l’historique, sans validation du MJ.
6. **Influence** : l’échec est mémorisé par personnage et par approche.
7. **Versions de pack** : correctif = texte seul, mineure = ajouts compatibles, majeure = peut invalider des fiches. Une progression incomplète bloque la publication, pas le test.
8. **Compendium** : limité aux packs actifs de la table, avec la possibilité d’élargir. Les entités bannies restent consultables, marquées « BANNI ».
9. **Historique en lecture seule** : on n’annule pas une entrée ; une correction est une nouvelle modification, elle-même tracée. L’annulation reste propre au journal de combat (EF-LOG-02).
10. **Valeur écrasée à la synchronisation** : l’entrée remplacée reste visible, barrée, avec un renvoi vers l’entrée « Conflit résolu ».
11. **Notes du joueur** : affichées dans l’onglet Notes de la fiche, groupées par rattachement ; les notes partagées par d’autres y apparaissent en lecture seule.
12. **Partage des notes** : le MJ comme les joueurs peuvent partager une note avec la table ; elle reste modifiable par son seul auteur. (Décision du porteur de projet.)
13. **Note modifiée sur deux appareils hors-ligne** : les deux versions sont conservées dans la note, l’auteur fusionne. (Décision du porteur de projet.)
14. **Présences** : saisies à la préparation de la séance, préremplies dans chaque rencontre (difficulté et partage des PX). Un absent ne gagne pas de PX.
15. **Clôture de séance** : additionne les PX des rencontres jouées, les ajoute aux fiches et à leur historique ; une rencontre non jouée est reportée à la séance suivante, gardée sans séance ou supprimée. Un seuil de niveau atteint déclenche une proposition de montée de niveau au joueur.
16. **Préparer, puis jouer sans réseau** : l’écran de préparation dit explicitement si tout est sur l’appareil, et quelle version d’une fiche sera utilisée si une synchronisation manque.
17. **Progression PX ou jalons** : choisie à la création de la table ([T8]), modifiable dans Configuration. En jalons, aucun PX sur les fiches ni dans la vue joueur ; la jauge de difficulté reste calculée en PX. (Décision du porteur de projet.)
18. **Après la clôture, le joueur voit** ses PX (ou le jalon) et les notes de la séance, pas le résumé des rencontres. (Décision du porteur de projet.)
19. **« Jouer tout de suite »** crée une séance datée du jour. (Décision du porteur de projet.)
20. **Jalons en cours de partie** : le MJ accorde un niveau à tout moment de la séance, pas seulement à la clôture ; chaque personnage concerné reçoit un bouton « Monter de niveau » sur sa fiche, qui lance l’assistant. Validé aussi : « Plus tard » réduit l’encadré en puce près du nom jusqu’à la montée ; le MJ peut encore accorder à la clôture (déjà servis cochés et grisés) ; hors-ligne, l’attribution part à la reconnexion et le bouton n’apparaît qu’après synchronisation des deux appareils. (Décision du porteur de projet.)
21. **Journal de rencontre et informations d’Étude** : réservés au MJ ; les joueurs ne les voient pas dans l’application, le MJ les annonce à la table. (Décision du porteur de projet.)
22. **Contenu homebrew modifié** : le MJ ne peut pas imposer la migration ; chaque joueur choisit de migrer ou de garder l’ancienne version ([H10]). (Décision du porteur de projet.)
23. **Changement de configuration en cours de campagne** ([F6]) : une nouvelle méthode de caractéristiques ne s’applique qu’aux prochaines créations ; passer en jalons fige les PX acquis. Les joueurs voient la nouvelle règle à la synchronisation. (Décision du porteur de projet.)
24. **Observation** ([F3]) : pas d’informations préparées ; le MJ consigne la découverte au journal, visible de lui seul, et peut la lier à un PNJ ou en faire une note.
25. **Égalités d’initiative** (EF-INI-04) : le MJ ordonne les monstres ex aequo, les joueurs leurs PJ, le MJ tranche entre monstre et PJ. L’ordre par défaut est une commodité affichée comme telle.
26. **Bouton de montée de niveau** (EF-SEA-05) : il dépend du mode de progression et affiche toujours son origine (seuil atteint, niveau accordé, dérogation).
27. **CA d’un monstre** (revue R3) : calculée depuis l’armure et le bouclier, formule affichée, ou naturelle / libre avec un libellé ; une incohérence en mode calculé alerte sans bloquer.
28. **Pavé de dégâts** (EF-PV-04) : « Vulnérabilité ×2 » et « Résistance ½ » sont des corrections manuelles ; la bascule « Coup critique » ne change pas le montant, elle déclenche les règles liées.
29. **Automatismes à 0 PV** (EF-PV-05, EF-PV-06, EF-CON-06) : inconscience, dégâts massifs, échecs de jets contre la mort, soins, stabilisation, Assommer et fin de concentration s’appliquent dans le pavé, annoncés dans l’aperçu et annulables au journal.
30. **Épuisement** (EF-CON-07) : −2 par niveau à tous les tests d20 et −1,50 m de Vitesse, visibles dans chaque décomposition ; le niveau 6 demande confirmation.
31. **Vue combat du joueur** (EF-VJ-01 à 06) : bascule automatique au lancement de la rencontre ; adversaires visibles sous leur seul nom ; la version du MJ prime en cas de conflit.
32. **Effets reçus, demandes de jet, repos de groupe** (EF-PJ-17, EF-VJ-05, EF-PJ-19) : l’état posé par un autre personnage et les jets à faire arrivent sur le téléphone du joueur concerné ; le MJ garde la main et saisit à sa place s’il est hors-ligne.
33. **Jet simple au MVP** (EF-DES-01 à 05) : « Saisir mon jet » et « Lancer » côte à côte partout où un jet précis est attendu ; ni lanceur libre ni historique des jets avant la V2. (Décision du porteur de projet, 25 octobre 2026.)
34. **Fiche à valider jouable** (EF-PJ-20) : elle sert en séance ; les corrections s’appliquent après sans perdre l’état de jeu.
35. **Jeu de données de référence** ([D1], §12.1) : les maquettes et les tests du moteur de règles utilisent les mêmes personnages, rencontres et séances. Une planche qui s’en écarte est un défaut.
36. **Erreur de connexion** ([A1]) : message unique « E-mail ou mot de passe incorrect », sans dire lequel, pour ne pas révéler l’existence d’un compte. Même principe pour « Mot de passe oublié » ([A2]) : « Si un compte existe… ». (Décision du porteur de projet.)
37. **Réinitialisation** ([A2], [A3]) : lien valable 1 heure, renvoi possible après 60 secondes ; nouveau mot de passe de 10 caractères au moins, différent de l’e-mail et du pseudo, absent des listes de mots de passe divulgués ; option cochée par défaut « Déconnecter mes autres appareils ». (Décision du porteur de projet.)
38. **Changement d’e-mail** ([A5]) : confirmation par lien sur la nouvelle adresse ; l’ancienne reste active jusque-là et reçoit un avertissement. L’e-mail et le mot de passe demandent le réseau ; le pseudo et l’avatar se modifient hors-ligne. (Décision du porteur de projet.)
39. **Méthodes de connexion** ([A6], [A7]) : un compte peut lier mot de passe, Google et Apple ; il en garde toujours au moins une. Un compte Google ou Apple sans mot de passe ne peut pas changer son e-mail avant d’en ajouter un. (Décision du porteur de projet.)
40. **Première connexion sans réseau** ([A4]) : le bouton est désactivé avec l’explication ; rien n’est mis en file (aucun identifiant stocké en attendant). (Décision du porteur de projet.)

## 5. Questions encore ouvertes

1. **Transfert de table** quand un MJ supprime son compte (décision 1 rediscutée par la revue) : ouverte en §14.3 du cahier.
2. La liste des opérations d’effets homebrew ([H3]) sera fixée avec le langage d’effets (§10, partie technique).
