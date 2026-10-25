# Conformité des maquettes au cahier des charges

> **Note de mise à jour (25 octobre 2026, pack Claude Code)** : le reste n° 1 (transfert de table) est tranché : table conservée sans MJ, fiches en lecture seule, aucun écran supplémentaire à dessiner (cahier §14.3). Revue finale des maquettes : `REVUE_MJ.md` §10, maquettes validées.

Revue du 25 octobre 2026, mise à jour contre la version du cahier qui intègre `REVUE_MJ.md`. Les références entre crochets renvoient aux planches du canevas « Maquettes M3 ».

Légende : ✅ couvert · 🟡 couvert en partie, l’écart est précisé · ⚙️ hors design (exigence technique, rien à dessiner).

## 1. Brief design (§9)

| Point | État | Où |
|---|---|---|
| Ton hybride : écrans de travail sobres, accueil, table et création plus évocateurs | ✅ | Combat et fiche [1a]–[2c] ; en-têtes texturés de table [T9], [S1], création [P1] |
| Titres en police fantasy, reste en sans-empattement, chiffres tabulaires | ✅ | [0] Fondations ; Cinzel + Roboto Flex dans `design_tokens.json` |
| Fond sombre chaud, un accent, 5 couleurs sémantiques réservées | ✅ | [0] ; tokens |
| La couleur ne porte jamais seule une information | ✅ | Icône + libellé sur chaque état, PV en chiffres, badges textuels |
| Grain discret sur en-têtes et cartes de table, jamais sur les données | ✅ | Règle dans `COMPOSANTS.md` § 1 |
| Icônes : 15 états, types de dégâts, actions | ✅ | [0] |
| Icônes : écoles de magie | ✅ | [G1], ajoutée lors de cette revue |
| Aucun logo, nom ou motif de la marque | ✅ | Vérifié sur toutes les planches |
| Thème clair prévu dans les tokens, livré en V1.5 | 🟡 | Tokens et contrastes prêts ; aucun écran rendu en clair |
| Points de rupture desktop / téléphone / tablette | ✅ | Desktop multi-panneaux [1c] ; téléphone une colonne + feuilles modales [1a], [1b] ; tablette deux panneaux [TB1]–[TB3] |
| Parcours 1 à 9 (§9.3) | ✅ | 1 [T1]–[T3] · 2 [T8]–[T11] · 3 [T12], [P1]–[P9] · 4 [P10], [P11], [G2] · 5 [C1] · 6 [C3]–[C11] · 7 [P12], [P13] · 8 [H2]–[H6], [E1]–[E8] · 9 [H7]–[H9] |
| États §9.5 sur chaque écran | ✅ | Table de correspondance dans `COMPOSANTS.md` § 3 |
| Composants clés §9.6 | ✅ | `COMPOSANTS.md` § 2 (58 composants) |

## 2. Inventaire des écrans (§9.4)

| Module | Écrans demandés | État | Où |
|---|---|---|---|
| Compte | Connexion / inscription, profil et réglages, appareils, consentements, export et suppression | ✅ | [T1], [T2], [T5], [T6] ; connexion [A1], [A4] ; mot de passe [A2], [A3] ; modification du compte [A5], [A6] ; profil desktop [A7] |
| Accueil | Tables, personnages, packs, état de synchronisation | ✅ | [T4], [T7], [G6] |
| Table | Vue d’ensemble, configuration, membres et invitations, séances, PNJ, rencontres, notes, packs actifs | ✅ | [T9], [F6], [T10], [T11], [S1]–[S9], [F4], [C2], [G5], [F5], [N3], [H9] |
| Personnage | Création en 9 étapes, fiche et ses 7 onglets, montée de niveau, repos, historique | ✅ | [P1]–[P9] ; onglets [2a], [P16], [F1], [P14], [G3], [P15], [F2], [N4] ; [P10], [P11], [G2], [S9] ; [P12], [P13] ; [N1], [N2] |
| Combat | Préparation, suivi, détail, dégâts / soins, conditions, concentration, Étude / Influence / Observation, journal, fin | ✅ | [C1], [1a]–[1c], [C8], [1b], [G4], [C5], [K4], [C9], [C10], [F3], [C11] |
| Compendium | Recherche transverse, fiche d’entité avec source | ✅ | [K1]–[K5] |
| Homebrew | Mes packs, 8 éditeurs, effets, prévisualisation, export, import | ✅ | [H1], [E3]–[E8], [H2], [H5], [H3], [H4], [H6], [H7], [H8] |

## 3. Exigences fonctionnelles

Identifiants du cahier mis à jour le 25 octobre 2026. La colonne « Revue » renvoie aux points de `REVUE_MJ.md`.

### Comptes et tables (§4.1, §4.2)

| ID | Sujet | État | Où, ou écart |
|---|---|---|---|
| EF-CPT-01 | Inscription et connexion, Google / Apple, 15 ans minimum | ✅ | [T2] avec l’erreur d’âge ; connexion [A1] (téléphone), [A4] (desktop) ; mot de passe oublié [A2], [A3] ; méthodes liées [A6] |
| EF-CPT-02 | Première connexion avec réseau, session valide hors-ligne | ✅ | [A4] : première connexion sans réseau expliquée |
| EF-CPT-03 | Profil : pseudo, avatar, langue, taille du texte, thème | ✅ | [T5], [A5], [A7] |
| EF-CPT-04 | Suppression avec export préalable ; tables du MJ laissées sans MJ | ✅ | [T6]. Transfert de MJ : décision ouverte (§14.3), rien à dessiner tant qu’elle n’est pas prise |
| EF-CPT-05 | Appareils connectés, déconnexion à distance | ✅ | [T5], [A7] ; « Déconnecter mes autres appareils » après un nouveau mot de passe [A3] |
| EF-CPT-06 | Consentement aux rapports de crash | ✅ | [T1], révocable dans [T5] |
| EF-CPT-07 / 08 | Erreur de connexion neutre, mot de passe oublié et nouveau mot de passe | ✅ | [A1], [A2], [A3] |
| EF-CPT-09 / 10 | Changement d’e-mail, méthodes de connexion liées | ✅ | [A5], [A6], [A7] |
| EF-CPT-11 | Première connexion sans réseau | ✅ | [A4] |
| EF-TAB-01 à 04 | Création et configuration de la table | ✅ | [T8], [F6] |
| EF-TAB-05 | Invitation lien / code / QR, 7 jours, révocable | ✅ | [T10], [T11] |
| EF-TAB-06 | Retrait d’un joueur, fiche archivée | ✅ | [T10] |
| EF-TAB-07 | Archivage de table | ✅ | [F6] |
| EF-TAB-08 | Rejoindre exige le réseau, demande mise en file | ✅ | [T12] hors-ligne |
| EF-TAB-09 | Visibilité entre joueurs, état qualitatif | ✅ | [T13], [T10], [F6] |
| EF-TAB-10 | Progression PX ou jalons choisie à la création | ✅ | [T8], [F6], [S7] |
| EF-TAB-11 | Changement de configuration en cours de campagne, daté dans l’activité | ✅ | [F6] |

### Séances et progression (§4.4)

| ID | Sujet | État | Où | Revue |
|---|---|---|---|---|
| EF-SEA-01 | Séances, « Jouer tout de suite » | ✅ | [S1], [S6] | |
| EF-SEA-02 | Présences, prêt hors-ligne | ✅ | [S2] | |
| EF-SEA-03 | Clôture en PX, partage entre présents | ✅ | [S4] | |
| EF-SEA-04 | Jalons accordés en séance ou à la clôture | ✅ | [S8], [S7] | |
| EF-SEA-05 | Bouton « Monter au niveau n » déverrouillé, avec son origine ; « Plus tard » | ✅ | [D2] (5 variantes), [2c] (jauge 7 475 / 14 000 PX), [S9] | R2 |
| EF-SEA-06 | Montée sans validation du MJ, tracée | ✅ | [P10], [N1] | |
| EF-SEA-07 | Ce que le joueur voit après la clôture | ✅ | [S5] | |

### Personnages (§5.2, §5.3)

| ID | Sujet | État | Où, ou écart | Revue |
|---|---|---|---|---|
| EF-PJ-01 | Multiclassage, prérequis 13 | ✅ | [G2] | |
| EF-PJ-02 / 03 | Valeurs calculées et décomposition au toucher | ✅ | [2b] | |
| EF-PJ-04 | Bottes : nombre, changement au repos long, effet sur l’attaque | ✅ | [F1], alignées sur [2a], [2c], [S9] | §3 |
| EF-PJ-05 | Dons par catégorie, seuls les éligibles | ✅ | [P11], [P10], [E5] | |
| EF-PJ-06 | Montée de niveau guidée | ✅ | [P10], [P11], [G2] | |
| EF-PJ-07 | Sorts : préparés, grimoire, rituels, mineurs, emplacements, pacte, multiclassage | ✅ | [P14] (9 préparés + 6 de domaine), [G3], [F5a], [F5b] | R4, F5 |
| EF-PJ-08 | Fiche de sort | ✅ | [P14], [K1] | |
| EF-PJ-09 | Une seule concentration, confirmation | ✅ | [P14], [J2] | |
| EF-PJ-10 | Inventaire, monnaie, équipé, harmonisation (3) | ✅ | [P15] | |
| EF-PJ-11 | Suivi : PV, DV, jets contre la mort, Inspiration, ressources, états, épuisement | ✅ | [2a], [C7], [F1], [F2], [C5] | |
| EF-PJ-12 | Repos court et long | ✅ | [P12], [P13] | |
| EF-PJ-13 | Historique en lecture seule, valeur écrasée barrée | ✅ | [N1], [N2] | |
| EF-PJ-14 | Homebrew figé, migrer ou conserver, choix du joueur | ✅ | [H10] | |
| EF-PJ-15 | Suggestions à la création et à la montée de niveau | ✅ | [J11] création ; [P10], [P11] montée de niveau | J6 |
| EF-PJ-16 | Proposition structurelle du MJ | ✅ | [F4a], [F4b] | F4 |
| EF-PJ-17 | Effets reçus, décomposition | ✅ | [J4], [J1] | J2 |
| EF-PJ-18 | Consommables, Inspiration à utiliser ou donner | ✅ | « Utiliser » dans l’inventaire [P15], puis [J7] ; [J8] | J4 |
| EF-PJ-19 | Repos de groupe | ✅ | Déclenché depuis [S3] et [C11], puis [J9], [J10] | J5 |
| EF-PJ-20 | Fiche en attente, jouable | ✅ | [J12] | J7 |
| EF-PJ-21 | Termes de règles cliquables | ✅ | [J13] | J8 |
| EF-PNJ-01 | PNJ en fiche complète ou en bloc de stats | ✅ | [G5] | |
| EF-PNJ-02 | Dupliquer, dossiers, réutiliser | ✅ | [C2], [F4] | |
| EF-PNJ-03 | Informations cachées par palier | ✅ | [C2], [E8] | |

### Combat (§6.1 à §6.3)

| ID | Sujet | État | Où, ou écart | Revue |
|---|---|---|---|---|
| EF-REN-01 à 05 | Rencontres par séance, ajout, difficulté, PV, duplication | ✅ | [C1], [F5], [S2] | |
| EF-INI-01 à 03 | Jets, initiative de groupe, surprise | ✅ | [C3], [C4], [C1] | |
| EF-INI-04 | Égalités selon le SRD : qui décide, ordre par défaut, glisser-déposer | ✅ | [C3] | R1 |
| EF-INI-05 à 07 | Tour suivant, ajout en cours, compteurs des monstres | ✅ | [1c], [C8] | |
| EF-INI-08 | Réaction des PJ disponible / utilisée | ✅ | [1c] côté MJ, ajouté lors de cette mise à jour ; [J1], [J2] côté joueur | F6 |
| EF-INI-09 | Vigilant : « Échanger avec… », sauf si Neutralisé | ✅ | [C3], ajouté lors de cette mise à jour | F6 |
| EF-PV-01 | Dégâts sur plusieurs cibles, résistances automatiques | ✅ | [G4] | |
| EF-PV-02 | PV temporaires consommés en premier, sans cumul | ✅ | [G4], [1b] | |
| EF-PV-03 | 0 PV : jets contre la mort, monstre hors de combat | ✅ | [C7], [1c] | |
| EF-PV-04 | « Vulnérabilité ×2 », « Résistance ½ », bascule « Coup critique » | ✅ | [1b] | R5 |
| EF-PV-05 | Automatismes à 0 PV, annulables | ✅ | [F2a] mort sur le coup, [F2c] stabilisé et liste des automatismes | F2 |
| EF-PV-06 | Assommer | ✅ | [F2b] | F2 |
| EF-CON-01 à 05 | 15 états, durées, rappels, concentration, fin des effets liés | ✅ | [0], [C5], [K4], [C6], [1b], [1c] | |
| EF-CON-06 | Fin automatique de la concentration (Inconscient, Neutralisé, mort) | ✅ | [F2c], texte complété lors de cette mise à jour | F2 |
| EF-CON-07 | Épuisement appliqué aux valeurs, confirmation au niveau 6 | ✅ | [F3a], [F3b] | F3 |

### Assistants, journal, notes (§6.4 à §6.6)

| ID | Sujet | État | Où, ou écart |
|---|---|---|---|
| EF-ACT-01 à 04 | Étude, Influence (2 étapes), Observation | ✅ | [C9], [C10], [F3] |
| EF-ACT-05 | Correspondances modifiables par pack | ⚙️ | Données de règles, sans écran dédié au MVP |
| EF-ACT-06 | Attitude persistante | ✅ | [C2], [F4] |
| EF-ACT-07 | Journal et Étude réservés au MJ | ✅ | [1c] ; absents de [J1]–[J3] |
| EF-LOG-01 à 03 | Journal, annulation, résumé de fin | ✅ | [1c], [TB1], [C11] |
| EF-NOT-01 à 03 | Notes, confidentialité, recherche hors-ligne | ✅ | [N3]–[N7] |
| EF-NOT-04 à 06 | Partage, onglet Notes de la fiche, conflit à deux versions | ✅ | [N3], [N4], [N1] |

### Jets de dés et vue combat du joueur (§6.7, §6.8)

| ID | Sujet | État | Où | Revue |
|---|---|---|---|---|
| EF-DES-01 à 03 | « Saisir mon jet » et « Lancer », formule, résultat détaillé modifiable | ✅ | [J6], [J7] ; [C4], [C7], [P12] conservés | J9 |
| EF-DES-04 | Jets concernés au MVP | ✅ | Initiative [C4], jets contre la mort [J6], DV [P12], sauvegarde demandée [J5], potion [J7] | J9 |
| EF-DES-05 | Hors MVP | — | Rien à dessiner | J9 |
| EF-VJ-01 à 03 | Bascule « En combat », bandeau de tour, ordre simplifié | ✅ | [J1], [J2] | F1 / J1 |
| EF-VJ-04 | Son personnage sans défiler | ✅ | [J1] (Aldric), [J2] (Mira, sorts et emplacements) | F1 / J1 |
| EF-VJ-05 | Demandes de jets envoyées au joueur | ✅ | [J5], [J6] | J3 |
| EF-VJ-06 | Arbitrage MJ, hors-ligne | ✅ | [J3] | F1 |

### Homebrew et compendium (§7.2)

| ID | Sujet | État | Où |
|---|---|---|---|
| EF-HB-01 à 03 | Éditeurs guidés, dérivation, test | ✅ | [E1]–[E8], [H3], [H4] ; CA calculée du monstre [E8] (R3) |
| EF-HB-04 / 05 | Métadonnées du pack, export signé | ✅ | [H6] |
| EF-HB-06 / 07 | Import avec aperçu, autre auteur = pack distinct | ✅ | [H7], [H8] |
| EF-HB-08 | Dupliquer un pack importé | ✅ | [H1] |
| EF-HB-09 / 10 | Activation figée, SRD verrouillé et bannissement | ✅ | [H9], [K5] |
| EF-HB-11 | Versions de pack, progression incomplète bloque la publication | ✅ | [H6], [E3] |
| EF-CMP-01 | Compendium limité aux packs actifs, entités bannies marquées | ✅ | [K1]–[K5] |

### Seconde revue (`REVUE_MJ.md` §8)

| # | Correction | État | Où |
|---|---|---|---|
| 1 | Initiative de Thalia +7 (Vigilant, don du Criminel) ; nouvelle égalité entre PJ | ✅ | [D1] ; [C3] : Thalia 15 + 7 = 22, égalité à 8 entre Brannoc et Mira (« Inès et Sam décident ») |
| 2 | Dons, compétences et traits d’espèce de chaque PJ | ✅ | [D1] : Aldric, Mira, Thalia, Brannoc, Kael |
| 3 | Disciple de la Vie dans les soins de Mira | ✅ | [J2] Mot de guérison 2d4 + 6 ; [P14] Mot de guérison, Soins, Mot de guérison de groupe ; [D1] |
| 4 | Aldric à 41 / 49 : « Blessé » | ✅ | [J1] |
| 5 | DD de Brannoc à 15 | ✅ | [G4], corrigé dès la passe précédente |
| 6 | Varga assommée (1 PV, Inconsciente) | ✅ | [C11] |

Alignement induit : Perception passive de Mira à 16 (Compétent) sur [1c].

### Données de référence (§12.1)

| Exigence | État | Où |
|---|---|---|
| Personnages et rencontres identiques dans les maquettes et les tests | ✅ | [D1] ; écrans de début de campagne datés de la séance 1 ([T9], [T10], [T13]) ; Compétent = Intuition [F2] ; DD de Brannoc à 15 [G4] |

## 4. Exigences non fonctionnelles visibles à l’écran

| ID | État | Où, ou écart |
|---|---|---|
| ENF-01 Hors-ligne | ✅ | États hors-ligne sur [P7], [T12], [N2], [N5], [S3], [S4] |
| ENF-02 Indicateur de synchronisation | ✅ | [0] ; en attente [P9], [S2] ; conflit [P16], [N1], [N3] |
| ENF-03 Conflits notifiés | ✅ | [P16], [N1] |
| ENF-07 Stockage persistant Web | ✅ | [G6], ajouté lors de cette revue |
| ENF-10 Export RGPD | ✅ | [T5], [T6] |
| ENF-11 Télémétrie avec consentement | ✅ | [T1] |
| ENF-12 Rappel de sauvegarde à 30 jours | ✅ | [G6], ajouté lors de cette revue |
| ENF-13 Distances affichées selon la langue | ✅ | En français, portées et vitesses en mètres (1,5 m pour 5 pieds). Le stockage en pieds est technique |
| ENF-14 Accessibilité | 🟡 | Icône + libellé, contraste AA vérifié, cibles de 48 dp, texte de 85 à 200 % ([T5]), sémantique dans `COMPOSANTS.md`. À tester en vrai avec VoiceOver et TalkBack |
| ENF-15 Actions dans le tiers inférieur | ✅ | [1a], [1b], [S3] |
| ENF-04 à 06, 08, 09 | ⚙️ | Performance, taille, plateformes, sécurité |

## 5. Restes

1. **Transfert de table** (EF-CPT-04, §14.3) : à dessiner quand la décision sera prise.
2. **Thème clair** : à rendre sur 2 ou 3 écrans avant la V1.5.
3. **ENF-14** : à vérifier avec un vrai lecteur d’écran une fois l’application développée.
