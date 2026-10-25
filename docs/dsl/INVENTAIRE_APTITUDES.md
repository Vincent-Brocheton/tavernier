# Inventaire des aptitudes du SRD 5.2.1 (FR) pour le DSL d'effets

Carte T-02 · cahier §10.3, §14.1 (risque « DSL trop pauvre »). Source : `docs/srd/FR_SRD_CC_v5.2.1.pdf`, pages 28 à 93 (classes, sous-classes, origines, dons), lues dans le texte officiel. Opérations : `DSL_V1.md`.

**Types** : **C** calculable (modifie une valeur de la fiche) · **R** compteur (utilisations récupérées au repos ou à un déclencheur) · **D** descriptif (texte seul). Une aptitude peut cumuler C, R et D ; la colonne indique ce que le moteur doit gérer, le texte est toujours affiché.

Ne sont pas listées comme aptitudes : « Sorts » / « Magie de pacte » (colonnes de `class_level`), « Sous-classe de … » (choix structurel), « Amélioration de caractéristique » et « Faveur épique » de chaque classe (`grant_feat` de catégorie `general` / `epic_boon`, comptés une fois par classe dans la ligne « Dons de niveau »).

## Barbare (p. 31-34)

| Niv. | Aptitude | Type | Opérations |
|---|---|---|---|
| 1 | Rage | R+D | `grant_resource` rage `by_level`, repos court (1) / long (tout) ; bonus de dégâts et résistances = état de combat → D |
| 1 | Défense sans armure | C | `ac_formula` 10 + DEX + CON, bouclier permis, `when.armor: none` |
| 1 | Bottes d'arme | C | `grant_mastery_slots` `by_level` (colonne Bottes d'arme) |
| 2 | Sens du danger | C | `grant_advantage` `saving_throw:dex`, sauf Neutralisé |
| 2 | Témérité | D | |
| 3 | Savoir primal | C+D | `choice` 1 `grant_proficiency` compétence de Barbare ; tests FOR en Rage → D |
| 5 | Attaque supplémentaire | C | `set_attacks_per_action` 2 |
| 5 | Déplacement rapide | C | `modify_speed` walk +10, `when.armor: not_heavy` |
| 7 | Instinct sauvage | C | `modify_initiative` `advantage` |
| 7 | Bond instinctif | D | |
| 9 | Coup brutal | D | |
| 11 | Rage implacable | D | |
| 13 | Coup brutal amélioré | D | |
| 15 | Rage persistante | R+D | `grant_resource` recharge `initiative` 1 / repos long |
| 17 | Coup brutal amélioré | D | |
| 18 | Puissance indomptable | D | |
| 20 | Champion primitif | C | `ability_bonus` FOR +4 et CON +4, max 25 |
| 3 | Voie du Berserker · Frénésie | D | |
| 6 | Voie du Berserker · Rage aveugle | D | immunité conditionnée à la Rage |
| 10 | Voie du Berserker · Représailles | D | |
| 14 | Voie du Berserker · Présence intimidante | R+D | `grant_resource` 1 / repos long |

## Barde (p. 35-37)

| Niv. | Aptitude | Type | Opérations |
|---|---|---|---|
| 1 | Inspiration bardique | R | `grant_resource` `max: ability_mod CHA min 1`, dé `by_level` (table du Barde), repos long |
| 2 | Expertise | C | `choice` 2 `grant_expertise` ; 2 de plus au niv. 9 |
| 2 | Touche-à-tout | C | `modify_check` `unproficient_ability_checks` + moitié de la maîtrise |
| 5 | Source d'inspiration | R | Inspiration bardique : recharge `short_rest` |
| 7 | Contre-charme | D | |
| 10 | Secrets magiques | C | `grant_spell_list_access` Barde, Clerc, Druide, Magicien |
| 18 | Inspiration supérieure | R | recharge `initiative` jusqu'à 2 |
| 20 | Verbe de la création | C+D | `grant_spell` mot de pouvoir guérisseur, mot de pouvoir mortel, `always_prepared` |
| 3 | Collège du Savoir · Maîtrises supplémentaires | C | `choice` 3 `grant_proficiency` compétence |
| 3 | Collège du Savoir · Mots cinglants | D | dépense d'Inspiration bardique |
| 6 | Collège du Savoir · Découvertes magiques | C | `grant_spell_list_access` Clerc, Druide, Magicien, 2 sorts toujours préparés |
| 14 | Collège du Savoir · Compétence hors pair | D | |

## Clerc (p. 38-42)

| Niv. | Aptitude | Type | Opérations |
|---|---|---|---|
| 1 | Ordre divin | C | `choice` Protecteur (`grant_proficiency` armes de guerre, armures lourdes) / Thaumaturge (`grant_spell_list_access` Clerc, 1, `max_level: 0` ; `modify_check` Arcanes et Religion + SAG min 1) |
| 2 | Conduit divin | R+D | `grant_resource` `by_level` (colonne Conduit divin), repos court (1) / long (tout) |
| 5 | Calcination de Mort-vivant | D | |
| 7 | Impacts bénis | C+D | `choice` Impact divin (D) / Incantation puissante (`modify_damage` sorts mineurs de Clerc + SAG) |
| 10 | Intervention divine | R+D | `grant_resource` 1 / repos long |
| 14 | Impacts bénis améliorés | C+D | |
| 20 | Intervention divine suprême | D | |
| 3 | Domaine de la Vie · Disciple de la Vie | C | soins des sorts par emplacement + 2 + niveau d'emplacement (calcul affiché sur la fiche de sort) |
| 3 | Domaine de la Vie · Sorts du domaine | C | `grant_spell` `always_prepared` par niveau (3, 5, 7, 9) |
| 3 | Domaine de la Vie · Survivance | D | dépense de Conduit divin |
| 6 | Domaine de la Vie · Guérisseur béni | D | |
| 17 | Domaine de la Vie · Guérison suprême | D | |

## Druide (p. 43-48)

| Niv. | Aptitude | Type | Opérations |
|---|---|---|---|
| 1 | Druidique | C | `grant_proficiency` langue druidique ; `grant_spell` communication avec les animaux `always_prepared` |
| 1 | Ordre primitif | C | `choice` Mage (`grant_spell_list_access` Druide, 1, `max_level: 0` ; `modify_check` Arcanes et Nature + SAG min 1) / Gardien (`grant_proficiency` armes de guerre, armures intermédiaires) |
| 2 | Forme sauvage | R+D | `grant_resource` `by_level` (colonne Forme sauvage), repos court (1) / long (tout) |
| 2 | Compagnon sauvage | D | |
| 5 | Regain sauvage | R+D | `grant_resource` 1 / repos long (emplacement contre Forme sauvage) |
| 7 | Fureur élémentaire | C+D | `choice` Incantation puissante (`modify_damage` sorts mineurs de Druide + SAG) / Attaques primitives (D) |
| 15 | Fureur élémentaire améliorée | D | |
| 18 | Incantation animale | D | |
| 20 | Archidruide | D | |
| 3 | Cercle de la Terre · Sorts du cercle | C | `choice` environnement (`replaceable_on: long_rest`), `grant_spell` `always_prepared` |
| 3 | Cercle de la Terre · Aval de la terre | D | dépense de Forme sauvage |
| 6 | Cercle de la Terre · Ressourcement | R | `grant_resource` 1 / repos long |
| 10 | Cercle de la Terre · Protégé de dame Nature | C | `grant_defense` immunité Empoisonné ; résistance selon l'environnement choisi |
| 14 | Cercle de la Terre · Sanctuaire de dame Nature | D | dépense de Forme sauvage |

## Ensorceleur (p. 49-55)

| Niv. | Aptitude | Type | Opérations |
|---|---|---|---|
| 1 | Sorcellerie innée | R+D | `grant_resource` 2 / repos long |
| 2 | Réserve arcanique | R | `grant_resource` points de Sorcellerie `by_level` (= niveau d'Ensorceleur), repos long |
| 2 | Métamagie | C+D | `choice` options de Métamagie `by_level` (table de l'Ensorceleur) (D) |
| 5 | Restauration ensorcelée | R | `grant_resource` 1 / repos long |
| 7 | Sorcellerie incarnée | D | |
| 20 | Apothéose arcanique | D | |
| 3 | Sorcellerie draconique · Résistance draconique | C | `modify_hp_max` `flat: 3`, `per_level: 1` ; `ac_formula` 10 + DEX + CHA, `when.armor: none` |
| 3 | Sorcellerie draconique · Sorts draconiques | C | `grant_spell` `always_prepared` par niveau |
| 6 | Sorcellerie draconique · Affinité élémentaire | C+D | `choice` type → `grant_defense` résistance ; bonus de dégâts CHA → D |
| 14 | Sorcellerie draconique · Ailes draconiques | R+D | `grant_resource` 1 / repos long |
| 18 | Sorcellerie draconique · Compagnon draconique | C+R | `grant_spell` convocation de dragon, `free_casts` 1 / repos long |

## Guerrier (p. 56-58)

| Niv. | Aptitude | Type | Opérations |
|---|---|---|---|
| 1 | Style de combat | C | `grant_feat` `category: fighting_style` (`replaceable_on: level_up`) |
| 1 | Second souffle | R+D | `grant_resource` `by_level {1:2, 4:3, 10:4}` (table p. 56), repos court (1) / long (tout) |
| 1 | Bottes d'arme | C | `grant_mastery_slots` `by_level {1:3, 4:4, 10:5, 16:6}` (table p. 56) |
| 2 | Fougue | R+D | `grant_resource` `by_level {2:1, 17:2}`, repos court |
| 2 | Sens tactique | D | dépense de Second souffle |
| 5 | Attaque supplémentaire | C | `set_attacks_per_action` 2 |
| 5 | Décalage tactique | D | |
| 9 | Inflexible | R+D | `grant_resource` `by_level {9:1, 13:2, 17:3}`, repos long |
| 9 | Botte tactique | D | |
| 11 | Double attaque supplémentaire | C | `set_attacks_per_action` 3 |
| 13 | Attaques avisées | D | |
| 20 | Triple attaque supplémentaire | C | `set_attacks_per_action` 4 |
| 3 | Champion · Critique amélioré | C | `set_crit_range` 19 |
| 3 | Champion · Athlète accompli | C+D | `modify_initiative` `advantage` ; `grant_advantage` `skill:athletics` ; déplacement après critique → D |
| 7 | Champion · Style de combat supplémentaire | C | `grant_feat` `category: fighting_style` |
| 10 | Champion · Héros du champ d'honneur | D | |
| 15 | Champion · Critique supérieur | C | `set_crit_range` 18 |
| 18 | Champion · Survivant | C+D | `grant_advantage` `death_saves` ; Résilience héroïque → D |

## Magicien (p. 59-63)

| Niv. | Aptitude | Type | Opérations |
|---|---|---|---|
| 1 | Savoir rituel | D | règle d'incantation gérée par le moteur de sorts (grimoire) |
| 1 | Restauration magique | R | `grant_resource` 1 / repos long |
| 2 | Érudition | C | `choice` 1 `grant_expertise` parmi Arcanes, Histoire, Intuition, Investigation, Médecine, Nature, Religion |
| 5 | Mémorisation de sort | D | |
| 18 | Maîtrise des sorts | C | `choice` 2 sorts → `grant_spell` `always_prepared`, lancer à volonté |
| 20 | Sorts de prédilection | C+R | `grant_spell` 2 sorts, `free_casts` 1 / repos court |
| 3 | Évocateur · Évocateur érudit | D | ajout de sorts au grimoire (choix d'inventaire de sorts) |
| 3 | Évocateur · Sort mineur appuyé | D | |
| 6 | Évocateur · Façonneur de sorts | D | |
| 10 | Évocateur · Évocation améliorée | C | `modify_damage` sorts d'Évocation de Magicien + INT |
| 14 | Évocateur · Surcharge magique | D | |

## Moine (p. 64-67)

| Niv. | Aptitude | Type | Opérations |
|---|---|---|---|
| 1 | Arts martiaux | C+D | dé d'Arts martiaux `by_level` (colonne Arts martiaux) ; DEX pour armes de Moine et mains nues ; action Bonus → D |
| 1 | Défense sans armure | C | `ac_formula` 10 + DEX + SAG, sans bouclier, `when.armor: none` |
| 2 | Credo du Moine | R+D | `grant_resource` points de Credo (= niveau de Moine), repos court |
| 2 | Déplacement sans armure | C | `modify_speed` walk `by_level` (colonne Déplacement sans armure), `when: {armor: none, shield: false}` |
| 2 | Métabolisme surnaturel | R | `grant_resource` 1 / repos long |
| 3 | Déviation d'assaut | D | |
| 4 | Chute ralentie | D | |
| 5 | Attaque supplémentaire | C | `set_attacks_per_action` 2 |
| 5 | Frappe étourdissante | D | dépense de Credo |
| 6 | Frappes renforcées | D | |
| 7 | Esquive totale | D | |
| 9 | Mouvement acrobatique | D | |
| 10 | Credo accru | D | |
| 10 | Autosubsistance | D | |
| 13 | Parade énergétique | D | |
| 14 | Survivant discipliné | C | `grant_proficiency` `saving_throw` toutes |
| 15 | Credo parachevé | R | recharge `initiative` jusqu'à 4 |
| 18 | Défense supérieure | D | |
| 20 | Esprit et corps | C | `ability_bonus` DEX +4 et SAG +4, max 25 |
| 3 | Credo de la Paume · Technique de la Paume | D | |
| 6 | Credo de la Paume · Plénitude physique | R | `grant_resource` `ability_mod SAG min 1` / repos long |
| 11 | Credo de la Paume · Foulée preste | D | |
| 17 | Credo de la Paume · Paume vibratoire | D | |

## Occultiste (p. 68-74)

| Niv. | Aptitude | Type | Opérations |
|---|---|---|---|
| 1 | Manifestations occultes | C+D | `choice` manifestations `by_level` ; chaque manifestation est une entité (ex. Armure d'ombres = `grant_spell` armure du mage à volonté) |
| 2 | Rouerie magique | R | `grant_resource` 1 / repos long |
| 9 | Communication avec le protecteur | C+R | `grant_spell` contact avec les plans `always_prepared`, `free_casts` 1 / repos long |
| 11 | Arcanum mystique | C+R | `choice` sorts 6e à 9e niveau, `free_casts` 1 / repos long chacun |
| 20 | Maître de l'occulte | D | |
| 3 | Protecteur Fiélon · Bénédiction du ténébreux | D | |
| 3 | Protecteur Fiélon · Sorts du Fiélon | C | `grant_spell` `always_prepared` par niveau |
| 6 | Protecteur Fiélon · Chance du ténébreux | R | `grant_resource` `ability_mod CHA min 1` / repos long |
| 10 | Protecteur Fiélon · Résistance fiélonne | C | `choice` type de dégâts (`replaceable_on: short_rest`) → `grant_defense` résistance |
| 14 | Protecteur Fiélon · Traversée des enfers | R+D | `grant_resource` 1 / repos long |

## Paladin (p. 75-79)

| Niv. | Aptitude | Type | Opérations |
|---|---|---|---|
| 1 | Imposition des mains | R | `grant_resource` `max: {ref: class_level, times: 5}`, repos long |
| 1 | Bottes d'arme | C | `grant_mastery_slots` 2 |
| 2 | Style de combat | C | `choice` `grant_feat` `fighting_style` / Combattant béni (2 sorts mineurs de Clerc) |
| 2 | Châtiment de paladin | C+R | `grant_spell` châtiment divin `always_prepared`, `free_casts` 1 / repos long |
| 3 | Conduit divin | R+D | `grant_resource` `by_level` (colonne Conduit divin), repos court (1) / long (tout) |
| 5 | Attaque supplémentaire | C | `set_attacks_per_action` 2 |
| 5 | Fidèle destrier | C+R | `grant_spell` appel de destrier `always_prepared`, `free_casts` 1 / repos long |
| 6 | Aura de protection | C+D | `modify_check` `saving_throws` + CHA min 1 (sur soi) ; aura sur les alliés → D |
| 9 | Abjuration d'ennemis | D | dépense de Conduit divin |
| 10 | Aura de courage | D | |
| 11 | Frappes radiantes | C | `modify_damage` `melee_weapon` et `unarmed` +1d8 radiants |
| 14 | Toucher réparateur | D | |
| 18 | Aura étendue | D | |
| 3 | Serment de Dévotion · Sorts du serment | C | `grant_spell` `always_prepared` par niveau |
| 3 | Serment de Dévotion · Arme sacrée | D | dépense de Conduit divin |
| 7 | Serment de Dévotion · Aura de dévotion | D | |
| 15 | Serment de Dévotion · Châtiment de protection | D | |
| 20 | Serment de Dévotion · Nimbe sacré | R+D | `grant_resource` 1 / repos long |

## Rôdeur (p. 80-83)

| Niv. | Aptitude | Type | Opérations |
|---|---|---|---|
| 1 | Ennemi juré | C+R | `grant_spell` marque du chasseur `always_prepared`, `free_casts` `by_level`, repos long |
| 1 | Bottes d'arme | C | `grant_mastery_slots` 2 |
| 2 | Fin explorateur | C | `choice` 1 `grant_expertise` ; `choice` 2 `grant_proficiency` langue |
| 2 | Style de combat | C | `choice` `grant_feat` `fighting_style` / Combattant druidique (2 sorts mineurs de Druide) |
| 5 | Attaque supplémentaire | C | `set_attacks_per_action` 2 |
| 6 | Arpenteur | C | `modify_speed` walk +10 `when.armor: not_heavy` ; climb et swim `equal_to: walk` |
| 9 | Expertise | C | `choice` 2 `grant_expertise` |
| 10 | Infatigable | R+D | `grant_resource` `ability_mod SAG min 1` / repos long |
| 13 | Chasseur implacable | D | |
| 14 | Voile de la nature | R | `grant_resource` `ability_mod SAG min 1` / repos long |
| 17 | Chasseur précis | D | |
| 18 | Sens sauvages | C | `grant_sense` blindsight 30 |
| 20 | Tueur implacable | D | |
| 3 | Chasseur · Savoir du Chasseur | D | |
| 3 | Chasseur · Proie du chasseur | D | `choice` (`replaceable_on: short_rest`), options descriptives |
| 7 | Chasseur · Tactiques défensives | D | idem |
| 11 | Chasseur · Proie du chasseur supérieure | D | |
| 15 | Chasseur · Défense de chasseur supérieure | D | |

## Roublard (p. 84-86)

| Niv. | Aptitude | Type | Opérations |
|---|---|---|---|
| 1 | Expertise | C | `choice` 2 `grant_expertise` ; 2 de plus au niv. 6 |
| 1 | Attaque sournoise | C+D | dés `by_level` (1d6 à 10d6) affichés sur la fiche ; conditions → D |
| 1 | Argot des voleurs | C | `grant_proficiency` langue argot des voleurs + `choice` 1 langue |
| 1 | Bottes d'arme | C | `grant_mastery_slots` 2 |
| 2 | Ruse | D | |
| 3 | Visée appliquée | D | |
| 5 | Frappe malicieuse | D | |
| 5 | Esquive instinctive | D | |
| 7 | Esquive totale | D | |
| 7 | Savoir-faire | D | |
| 11 | Frappe malicieuse améliorée | D | |
| 14 | Coups vicieux | D | |
| 15 | Esprit fuyant | C | `grant_proficiency` `saving_throw` SAG et CHA |
| 18 | Insaisissable | D | |
| 20 | Coup de chance | R | `grant_resource` 1 / repos court |
| 3 | Voleur · Mains lestes | D | |
| 3 | Voleur · Monte-en-l'air | C+D | `modify_speed` climb `equal_to: walk` ; saut DEX → D |
| 9 | Voleur · Furtivité suprême | D | |
| 13 | Voleur · Utilisation d'objets magiques | C+D | `modify_attunement_slots` 4 ; charges et parchemins → D |
| 17 | Voleur · Réflexes de voleur | D | |

## Dons de niveau (toutes classes)

| Niv. | Aptitude | Type | Opérations |
|---|---|---|---|
| 4, 8, 12, 16 (+6, 14 Guerrier ; +10 Roublard) | Amélioration de caractéristique (aptitude) | C | `grant_feat` `category: general` |
| 19 | Faveur épique (aptitude) | C | `grant_feat` `category: epic_boon` |

## Espèces (p. 88-91)

| Espèce | Trait | Type | Opérations |
|---|---|---|---|
| Drakéide | Ascendance draconique | C | `choice` type de dragon |
| Drakéide | Souffle | R+D | `grant_resource` `proficiency_bonus` / repos long ; dégâts `by_level` |
| Drakéide | Résistance aux dégâts | C | `grant_defense` résistance au type choisi |
| Drakéide | Vision dans le noir | C | `grant_sense` darkvision 60 |
| Drakéide | Vol draconique (niv. 5) | R+D | `grant_resource` 1 / repos long |
| Elfe | Ascendance féerique | C | `grant_advantage` JS contre Charmé |
| Elfe | Lignage elfique | C+R | `choice` drow / sylvestre / haut-elfe → `grant_spell` niv. 1, 3, 5, `free_casts` 1 / repos long ; sylvestre `modify_speed` walk +5 (30 → 35 pieds) ; drow `grant_sense` 120 |
| Elfe | Sens aiguisés | C | `choice` `grant_proficiency` Intuition / Perception / Survie |
| Elfe | Transe | D | |
| Elfe | Vision dans le noir | C | `grant_sense` darkvision 60 |
| Gnome | Ruse gnome | C | `grant_advantage` JS INT, SAG, CHA |
| Gnome | Lignage gnome | C+R | `choice` → `grant_spell` |
| Gnome | Vision dans le noir | C | `grant_sense` darkvision 60 |
| Goliath | Ascendance de géant | R+D | `choice` ; `grant_resource` `proficiency_bonus` / repos long |
| Goliath | Forme de géant (niv. 5) | R+D | `grant_resource` 1 / repos long |
| Goliath | Forte carrure | D | capacité de charge hors MVP |
| Halfelin | Brave | C | `grant_advantage` JS contre Effrayé |
| Halfelin | Agilité halfeline | D | |
| Halfelin | Chance | D | |
| Halfelin | Discrétion naturelle | D | |
| Humain | Ingénieux | R | Inspiration héroïque au repos long |
| Humain | Compétent | C | `choice` 1 `grant_proficiency` compétence |
| Humain | Polyvalent | C | `grant_feat` `category: origin` |
| Nain | Résistance naine | C | `grant_defense` résistance poison ; `grant_advantage` JS contre Empoisonné |
| Nain | Ténacité naine | C | `modify_hp_max` `per_level: 1` |
| Nain | Connaissance de la pierre | R+D | `grant_resource` `proficiency_bonus` / repos long |
| Nain | Vision dans le noir | C | `grant_sense` darkvision 120 |
| Orc | Poussée d'adrénaline | R+D | `grant_resource` `proficiency_bonus` / repos court |
| Orc | Acharnement | R+D | `grant_resource` 1 / repos long |
| Orc | Vision dans le noir | C | `grant_sense` darkvision 120 |
| Tieffelin | Héritage fiélon | C+R | `choice` → `grant_defense` résistance + `grant_spell` niv. 1, 3, 5 |
| Tieffelin | Présence d'outre-monde | C | `grant_spell` thaumaturgie |
| Tieffelin | Vision dans le noir | C | `grant_sense` darkvision 60 |

## Historiques (p. 87)

| Historique | Élément | Type | Opérations |
|---|---|---|---|
| Acolyte, Criminel, Sage, Soldat | Valeurs de caractéristique | C | règle d'intégrité §11.3 (pas un effet : `background_ability`, distribution 2-1 / 1-1-1, plafond 20) |
| Acolyte, Criminel, Sage, Soldat | Don | C | `grant_feat` (don d'origines désigné) |
| Acolyte, Criminel, Sage, Soldat | Compétences et outil | C | `grant_proficiency` ×3 (outil au choix : `choice`) |

## Dons (p. 92-93)

| Catégorie | Don | Type | Opérations |
|---|---|---|---|
| Origines | Doué | C | `choice` 3 `grant_proficiency` compétence ou outil |
| Origines | Initié à la magie | C+R | `choice` liste ; 2 sorts mineurs ; `grant_spell` 1er niveau `always_prepared`, `free_casts` 1 / repos long |
| Origines | Sauvagerie martiale | D | |
| Origines | Vigilant | C+D | `modify_initiative` `add: proficiency_bonus` ; Échange d'Initiative → D |
| Général | Amélioration de caractéristique | C | `choice` +2 / +1 +1 → `ability_bonus` max 20 |
| Général | Empoigneur | C+D | `choice` FOR / DEX → `ability_bonus` +1 max 20 ; reste → D |
| Style de combat | Archerie | C | `modify_check` `scope: ranged_weapon_attack` +2 (voir point 1) |
| Style de combat | Armes à deux mains | D | |
| Style de combat | Combat à deux armes | D | |
| Style de combat | Défense | C | `modify_ac` +1, `when.armor: any` |
| Faveur épique | Faveur d'attaque irrésistible | C+D | `ability_bonus` +1 (choix), max 30 |
| Faveur épique | Faveur de déplacement dimensionnel | C+D | idem |
| Faveur épique | Faveur de l'esprit nocturne | C+D | idem |
| Faveur épique | Faveur de prouesse martiale | C+D | idem |
| Faveur épique | Faveur de mémoire magique | C+R | idem ; `grant_resource` 1 / repos long |
| Faveur épique | Faveur de Vision lucide | C | idem ; `grant_sense` truesight 60 |
| Faveur épique | Faveur du destin | C+R | idem ; `grant_resource` 1 / repos court ou long |

## Points tranchés le 25 octobre 2026 (voir DSL_V1.md)

1. **Archerie** (+2 au toucher à distance) : la proposition l'exprime avec `modify_check` `scope: ranged_weapon_attack`. Alternative : une opération dédiée `modify_attack`. Retenu : élargir `modify_check` aux jets d'attaque (scopes `ranged_weapon_attack`, `melee_weapon_attack`), pour garder la liste courte.
2. **Bonus de Rage, Sorcellerie innée, Arme sacrée** : conditionnés à un état de combat, ils restent descriptifs en v1 (principe 4). Retenu. La vue combat (M3) pourra les promouvoir via une v2 avec `when.state`.
3. **Disciple de la Vie, Arts martiaux, Attaque sournoise** : ce sont des valeurs affichées (soins, dé, dégâts) plus que des modificateurs de la fiche. Retenu : les porter par `class_level` (colonnes Attaque sournoise, dé d'Arts martiaux) et par un champ `healing_bonus` de la sous-classe, sans nouvelle opération.
