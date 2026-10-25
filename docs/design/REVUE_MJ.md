# Revue MJ des maquettes M3

Revue du 25 octobre 2026, faite du point de vue d'un MJ et d'un joueur réguliers, contre le cahier des charges et le SRD 5.2.1 français. Les références entre crochets renvoient aux planches du canevas « Maquettes M3 ».

**Verdict : les maquettes sont conformes à la vision et peuvent partir en développement après les corrections ci-dessous.** Le langage visuel respecte le brief (sombre, dense, Cinzel limité aux titres, couleur jamais seule). Aucune mention de la marque. Le vocabulaire est celui du SRD français. Les règles sont justes dans l'immense majorité des cas : j'ai recalculé les fiches, les budgets de rencontre, les PX et les sorts, et presque tout tombe juste au point près.

Légende : 🔴 à corriger avant développement · 🟠 à corriger, sans bloquer · 🟢 amélioration proposée.

---

## 1. Ce qui a été vérifié et qui est juste

Pour éviter de revérifier plus tard, voici ce qui a été recalculé et validé :

- **Aldric, Guerrier 5 Champion** [2a], [2b], [2c] : FOR 18 (15 + 2 Soldat + 1 Amélioration), PV 49, CA 19 (cotte de mailles 16 + bouclier 2 + Défense 1), Initiative +4 avec Avantage (Vigilant + Athlète accompli), 4 bottes d'armes au niveau 5, Second souffle 1d10 + 5 avec 3 utilisations.
- **Création niveau 1** [3b], [P1]–[P8] : coûts d'acquisition par points, Historiques du SRD (caractéristiques, dons, équipement), espèces 2024 sans bonus, langues courantes, lots d'équipement du Guerrier, récapitulatif (PV 12, CA 17, Initiative +3).
- **Montée de niveau et repos** [P10]–[P13], [G2] : PV moyens, dons éligibles (les dons d'origines sont bien accessibles à l'Amélioration de caractéristique), prérequis de multiclassage 13, repos court (1 PV minimum), repos long 2024 (tous les dés de vie récupérés, un seul repos long par 24 h).
- **Sorts** [P14], [G3], [K1] : DD et attaque, emplacements, nombre de sorts préparés 2024, grimoire de 14 sorts, rituels sans préparation, copie à 50 po et 2 heures par niveau, écoles et temps d'incantation 2024 (Mot de guérison en action Bonus, Arme spirituelle avec concentration).
- **Combat** [1a]–[1c], [C3]–[C8], [G4] : DD de concentration, surprise avec Désavantage, jets contre la mort, Boule de feu sur 4 cibles (moitié, puis résistance, puis PV temporaires), actions et résistances légendaires, recharge.
- **Assistants** [C9], [C10], [F3] : domaines de connaissance de l'Étude par type de créature, Influence en deux étapes (disposée, réticente, hésitante), Avantage ou Désavantage selon l'attitude, DD 15 ou Intelligence, 24 heures avant de retenter la même approche.
- **Rencontres et PX** [C1], [T9], [S2], [S4], [C11] : budgets 2024 par niveau, partage des PX entre présents, seuils de niveau (6 500 et 14 000).
- **Éditeurs** [E1]–[E8], [H2] : niveaux de sous-classe du Guerrier (3, 7, 10, 15, 18), catégories de dons, 3 caractéristiques par Historique, bonus de maîtrise et PX calculés par FP.

---

## 2. Erreurs de règles

### 🔴 R1. Égalités d'initiative [C3]

**Constat.** L'écran départage par la Dextérité (« Vétérans avant Loups sanguinaires, Dextérité +3 contre +2 »). Ce n'est pas la règle du SRD 5.2.1. L'erreur venait du cahier des charges (EF-INI-04), qui a été corrigé.

**Règle.** Le MJ ordonne les monstres ex aequo. Les joueurs ordonnent leurs PJ ex aequo. Entre un monstre et un PJ, le MJ tranche.

**Attendu.**
- L'application propose un ordre par défaut (par bonus d'initiative, à titre de commodité) sans le présenter comme une règle.
- Chaque égalité porte un badge qui dit qui décide : « Égalité · le MJ décide », « Égalité · Hugo et Léo décident ».
- En cas d'égalité entre PJ, les joueurs concernés peuvent réordonner depuis leur téléphone, ou le MJ le fait pour eux.
- Le texte d'aide de l'encadré « Égalité à 15 » devient : « Égalité à 15 entre deux groupes de monstres : vous choisissez l'ordre. Glissez pour le changer. »

### 🟠 R2. Bouton « Monter au niveau 6 » : préciser pourquoi il apparaît [2c]

**Constat.** La fiche desktop d'Aldric affiche « Monter au niveau 6 » sans dire ce qui l'a déverrouillé. Ce n'est pas une erreur en soi : dans une table en jalons, le bouton est légitime dès que le MJ a accordé le niveau, quel que soit le total de PX. Mais l'écran ne précise ni le mode de progression de la table ni l'origine du déverrouillage. En table en PX, avec 7 475 PX sur 14 000, il ne devrait pas apparaître.

**Attendu.** Le bouton dépend du mode de progression choisi pour la table (EF-TAB, décision 17), et il dit toujours pourquoi il est là :

| Mode de la table | Le bouton apparaît quand… | Libellé d'origine affiché |
| --- | --- | --- |
| Points d'expérience | le total atteint le seuil du niveau suivant | « Seuil de 14 000 PX atteint » |
| Jalons | le MJ a accordé le niveau, en séance ou à la clôture [S8], [S7] | « Niveau 6 accordé par Camille · motif du jalon » |
| Les deux | le MJ accorde un niveau manuellement, hors seuil (dérogation tracée) | « Niveau 6 accordé par Camille (dérogation) » |

Le reste du temps, l'en-tête montre la progression : « 7 475 / 14 000 PX » en table en PX, rien ou « Prochain jalon : décidé par le MJ » en table en jalons.

Sur [2c], ajouter l'encadré d'origine de [S9] au-dessus du bouton, ou une infobulle sur le bouton, pour que le joueur et le MJ sachent d'où vient la montée de niveau.

### 🟠 R3. CA du monstre non calculée [E8]

**Constat.** « CA 17 (cuirasse, bouclier) » avec DEX 14 donne en réalité 18 (cuirasse 14 + DEX plafonnée à +2, + bouclier 2). L'éditeur calcule le FP, les PX, le bonus de maîtrise et les PV, mais laisse la CA en saisie libre.

**Attendu.** Deux modes de CA dans l'éditeur de monstre :
- **calculée** : choix d'une armure et d'un bouclier du SRD ou des packs, avec la formule affichée (« 14 cuirasse + 2 DEX (max 2) + 2 bouclier = 18 ») ;
- **naturelle ou libre** : saisie avec un libellé (« armure naturelle »).

En mode calculé, une incohérence entre la valeur et l'équipement déclenche une alerte de vérification non bloquante.

### 🟠 R4. Sorts du Clerc incomplets [P14]

**Constat.**
- Le compteur dit « Préparés : 9 / 9 », mais seuls 6 sorts non liés au domaine sont listés.
- Le domaine de la Vie au niveau 5 accorde aussi **Retour à la vie**, absent de la liste (6 sorts de domaine annoncés, 5 affichés).

**Attendu.** Lister 9 sorts préparés hors domaine et les 6 sorts de domaine, Retour à la vie compris. Cet écran servira de référence au développement : les compteurs doivent correspondre exactement au contenu.

### 🟢 R5. Touches ×2 et ½ du pavé de dégâts [1b]

**Constat.** Sans libellé, « ×2 » se lit comme un coup critique. Or un critique double les dés, pas le total.

**Attendu.** Libeller « Vulnérabilité ×2 » et « Résistance ½ ». Ce sont des corrections manuelles, puisque les résistances des fiches s'appliquent déjà automatiquement. Ajouter une bascule « Coup critique », qui ne change pas le montant saisi mais déclenche les règles liées (deux échecs de jet contre la mort sur un PJ à 0 PV, voir F2).

---

## 3. Incohérences du jeu de données

Ces écarts ne sont pas des erreurs de règles, mais Claude Code se servira des maquettes comme données de test. Les mêmes personnages doivent donc être identiques partout.

| Écart | Écrans | Correction |
| --- | --- | --- |
| Bottes d'Aldric : Épée longue, Javeline, Hache d'armes, Épée à deux mains | [2a], [2c], [S9] | Garder cette liste partout |
| Bottes d'Aldric : Épée longue, Hachette, Arc long, Marteau de guerre ; attaques à la hachette et à l'arc long | [F1] | Aligner sur la liste ci-dessus ; attaques Épée longue, Javeline, Mains nues |
| Inventaire sans hachette ni arc long | [P15] | Cohérent avec la correction de [F1] |
| Compétence de l'espèce (Compétent) : Intuition | [P5], [P8] | Garder Intuition |
| Compétence de l'espèce (Compétent) : Perception | [F2] | Remplacer par Intuition |
| Séance 12 avec des PJ de niveau 1, « Embuscade » jugée Modérée | [T9], [T10], [T13] | Ces écrans racontent le début de campagne : les dater de la séance 1 ou les passer au niveau 5 |
| Séance 12 avec des PJ de niveau 5, « Embuscade » sous le budget Faible | [S2], [1c], [C11] | Référence à garder |

**Proposition.** Ajouter au canevas une planche « Jeu de données de référence » qui fixe chaque personnage (classe, niveau, caractéristiques, bottes, sorts, inventaire, PX) et chaque rencontre. Elle servira de fixtures aux tests du moteur de règles (§12.1 du cahier).

---

## 4. Manques fonctionnels : descriptions

### 🔴 F1. Vue combat du joueur (téléphone)

**Constat.** Le joueur voit l'initiative à saisir [C4] et ses jets contre la mort [C7], mais aucun écran ne montre ce qu'il voit pendant tout le reste du combat. C'est pourtant l'écran que chaque joueur aura sous les yeux pendant la moitié d'une séance. Le cahier lui permet de mettre à jour ses PV et ses états.

**Description.**
- **Déclenchement.** Quand le MJ lance une rencontre où figure son PJ, la fiche du joueur bascule sur un écran « En combat » (retour à la fiche complète en un geste).
- **Bandeau de tour** en haut, toujours visible :
  - « Round 3 · Tour du Chef de bande · vous jouez dans 2 tours » ;
  - à son tour : bandeau `primaryContainer` « C'est votre tour », avec rappel de ses ressources d'action (action, action Bonus, réaction, déplacement), que le joueur coche au fil du tour.
- **Ordre d'initiative simplifié** :
  - les PJ avec leur état de santé qualitatif (EF-TAB-09) ;
  - les adversaires que le MJ a rendus visibles, sous leur seul nom, sans PV ni CA ;
  - les adversaires cachés n'apparaissent pas ;
  - pas de journal, pas d'informations d'Étude (décision 21).
- **Son personnage** :
  - PV, PV temporaires, boutons Dégâts, Soins, PV temp. ;
  - états actifs avec leur durée ;
  - concentration en cours ;
  - réaction utilisée ou non ce round.
- **Actions rapides** : ses attaques avec toucher, dégâts et effet de botte (comme [F1]), et ses sorts préparés avec emplacements restants. Lancer un sort décompte l'emplacement, et lancer un sort à concentration propose de mettre fin au précédent (EF-PJ-09).
- **Règle d'arbitrage** : toute modification du joueur apparaît chez le MJ et dans le journal du MJ. Si le MJ a modifié la même valeur, la version du MJ prime (ENF-03).
- **Hors-ligne** : sans réseau, l'écran affiche le dernier état connu avec « Hors-ligne : dites vos changements au MJ ». Les modifications locales partent à la reconnexion.

**Écrans à produire** : vue en combat (pas son tour), vue « C'est votre tour », vue hors-ligne.

### 🔴 F2. Automatismes à 0 PV et mort

**Constat.** [1c] et [C7] montrent l'état à 0 PV, mais pas ce que l'application fait quand un PJ y tombe ou y subit des dégâts. Ce sont des règles faciles à oublier en séance.

**Règles SRD 5.2.1 à appliquer automatiquement dans le pavé de dégâts** (avec possibilité d'annuler) :
1. **Tomber à 0 PV** : le PJ reçoit l'état Inconscient et commence ses jets contre la mort. Un monstre est marqué hors de combat (le MJ peut le traiter comme un personnage).
2. **Dégâts massifs** : si l'excédent de dégâts après 0 PV est au moins égal aux PV max, le PJ meurt sur le coup. L'aperçu l'annonce avant de valider : « Mort sur le coup : excédent 12 ≥ PV max 12 ».
3. **Dégâts à 0 PV** : un échec de jet contre la mort, deux si la bascule « Coup critique » est active. Mort si les dégâts atteignent les PV max.
4. **Soins à 0 PV** : le PJ retrouve des PV, l'état Inconscient est retiré, les compteurs de jets contre la mort sont remis à zéro.
5. **Stabilisé** : trois réussites, ou action Soutien avec un test de Sagesse (Médecine) DD 10 réussi. Le PJ ne fait plus de jets mais reste Inconscient à 0 PV. Le moindre dégât le remet aux jets contre la mort.
6. **Assommer** : quand une attaque de corps à corps ferait tomber une créature à 0 PV, le pavé propose « Assommer » : 1 PV et état Inconscient. C'est exactement le cas de Varga capturée [C11].
7. **Fin de concentration** : la concentration s'arrête automatiquement si le lanceur devient Inconscient ou Neutralisé, ou meurt. Les effets liés sont retirés avec confirmation (EF-CON-05).

**Écrans à produire** : aperçu du pavé avec alerte de mort sur le coup ; option « Assommer » ; carte d'un PJ Stabilisé.

### 🟠 F3. Épuisement appliqué aux valeurs

**Constat.** L'épuisement est suivi (0 à 6), mais on ne voit pas son effet sur la fiche.

**Règle 2024.** Chaque niveau retire 2 à tous les tests d20 (attaques, sauvegardes, tests de caractéristique, initiative) et 1,50 m à la Vitesse. Au niveau 6, le personnage meurt. Un repos long retire un niveau.

**Attendu.**
- Les valeurs touchées (Vitesse, attaques, JS, compétences, initiative) montrent la pénalité dans leur décomposition [2b] : « −4 Épuisement (niveau 2) ».
- Une puce « Épuisement 2 · −4 aux tests d20 · Vitesse −3 m » sur la carte de combattant et en tête de fiche.
- Passer au niveau 6 demande une confirmation explicite, puis marque le personnage comme mort.

### 🟠 F4. Proposition structurelle du MJ, côté joueur

**Constat.** Le cahier (§2.2) prévoit qu'une modification structurelle par le MJ (niveau, don, Historique) soit une proposition que le joueur accepte. L'historique en montre la trace [N1], mais pas l'écran de réception.

**Attendu.**
- Côté MJ : depuis la fiche d'un PJ, « Proposer une modification » ouvre l'assistant concerné en mode proposition, avec un motif obligatoire.
- Côté joueur : un encadré en tête de fiche, comme [S9] : « Camille propose : remplacer le don Doué par Initié à la magie · Motif : … », avec un aperçu avant et après des valeurs touchées, et les boutons « Refuser » (avec message) et « Accepter ».
- L'acceptation applique la modification et l'inscrit dans l'historique. Les dérogations directes (décision 2) restent possibles et tracées.

### 🟠 F5. Magie de pacte et emplacements de multiclassage

Déjà relevé dans `CONFORMITE.md`. Description pour le dessiner :
- **Occultiste** : un bloc « Magie de pacte » séparé des emplacements de sort, avec un nombre d'emplacements qui sont tous du même niveau (« 2 emplacements du 3e niveau »), récupérés au repos court. Un sort d'Occultiste se lance toujours au niveau de pacte.
- **Multiclassage** : la table d'emplacements combinée (niveau de lanceur de sorts calculé, avec sa décomposition au toucher : « Clerc 3 + Paladin 4 ÷ 2 = 5 »), les sorts préparés listés par classe, chacun avec sa caractéristique et son DD. La magie de pacte reste à part.

### 🟢 F6. Réactions des PJ et échange d'initiative

- La carte de combattant d'un PJ affiche, comme pour les monstres [C8], « Réaction disponible / utilisée », réinitialisée au début de son tour. Le MJ sait alors qui peut encore faire une attaque d'opportunité.
- **Vigilant** permet d'échanger son initiative avec un allié consentant juste après le jet. À l'écran d'initiative [C3], un PJ qui a ce don reçoit un bouton « Échanger avec… ».

---

## 5. Point de vue joueur

Les écrans joueur sont solides pour la création, la montée de niveau et la lecture de la fiche. Ils pensent moins au moment où l'on joue. Points classés du plus important au moins important.

### 🔴 J1. Une vue « En combat » pour le joueur

C'est le manque F1, décrit au §4, vu du joueur. Sur la fiche téléphone [2a], les attaques sont en bas d'un long défilement. En combat, le joueur doit avoir sous le pouce, sans défiler : ses PV, ses attaques, ses sorts préparés avec leurs emplacements, et ses ressources (Second souffle, Fougue…).

### 🔴 J2. Effets reçus d'autres personnages

**Constat.** Quand Mira lance Bénédiction, le MJ voit « Béni » sur Aldric [1c], mais rien n'apparaît sur la fiche d'Aldric. C'est pourtant son joueur qui ajoute le 1d4 à ses jets.

**Attendu.**
- Un bloc « Effets reçus » sur la fiche (onglet Principal et vue En combat) : nom de l'effet, source, durée restante, effet en une ligne. Exemple : « Béni · de Mira · +1d4 aux attaques et aux JS · 8 rounds ».
- Même traitement pour les malus et les états posés par d'autres : Effrayé, Empoisonné, Entravé, etc.
- Les valeurs touchées l'indiquent dans leur décomposition [2b] : « +1d4 Béni (Mira) ».
- L'effet disparaît de la fiche quand il expire ou quand la concentration du lanceur prend fin (EF-CON-05).

### 🔴 J3. Demandes de jets envoyées au joueur concerné

**Constat.** Les alertes de concentration [1c] et de sauvegarde à refaire [C6] n'existent que chez le MJ.

**Attendu.**
- Quand un PJ doit faire un jet (concentration, sauvegarde à refaire en fin de tour, jet contre la mort), une demande apparaît sur le téléphone de son joueur : type de jet, DD, son bonus, saisie du d20 ou lancer par l'application (voir J9).
- Le résultat remonte chez le MJ, qui garde la main et peut le saisir lui-même si le joueur est hors-ligne.
- Les états qui expirent sur son personnage sont signalés au joueur au même moment qu'au MJ.

### 🟠 J4. Objets et Inspiration utilisables

**Constat.** L'inventaire [P15] montre deux potions de guérison sans moyen de les utiliser.

**Attendu.**
- Bouton « Utiliser » sur les consommables. Pour une potion de guérison : rappel « action Bonus », saisie ou lancer du soin (2d4 + 2), application aux PV, quantité décomptée, entrée dans l'historique.
- Inspiration héroïque : bouton « Utiliser » (relancer un dé, en gardant le nouveau résultat) et, quand le personnage en reçoit une alors qu'il en a déjà, proposition « Donner à… » un autre PJ qui n'en a pas, comme le prévoit la règle.

### 🟠 J5. Repos déclenché pour le groupe

**Constat.** Chaque joueur fait son repos seul [P12], [P13]. À table, c'est le MJ qui annonce le repos.

**Attendu.**
- Le MJ déclenche « Repos court » ou « Repos long » pour les PJ présents, depuis la séance en cours [S3] ou la fin de rencontre [C11].
- Chaque joueur reçoit l'écran de repos sur son téléphone : dépense des dés de vie pour un repos court, récapitulatif de ce qui revient pour un repos long. Le MJ voit qui a terminé.
- Le repos individuel reste possible hors séance.

### 🟠 J6. Suggestions pour les débutants

**Constat.** La création bloque bien les erreurs, mais n'aide pas à choisir. Le persona Hugo découvre les règles.

**Attendu.**
- Un bouton « Suggérer » à chaque étape de la création et de la montée de niveau : répartition des points conseillée pour la classe, compétences et don cohérents avec l'Historique, bottes d'armes pour les armes de l'équipement de départ.
- Une suggestion se présente comme un choix prérempli, modifiable, avec sa raison en une ligne. Le modèle existe déjà sur [P2] (« Bon accord : Soldat augmente Force et Constitution »).

### 🟠 J7. Fiche en attente de validation, mais jouable

**Constat.** Le statut « À valider » ne dit pas si la fiche peut servir en séance.

**Attendu.** Un bandeau « En attente de validation par Camille · utilisable en jeu ». La fiche reste jouable : PV, attaques, sorts, repos. Si le MJ demande des corrections, elles s'appliquent après la séance, sans perdre l'état de jeu (PV, emplacements utilisés).

### 🟢 J8. Termes de règles cliquables

Dans les aptitudes, les sorts et les effets, les termes de règles (Désavantage, Agrippé, action Bonus, Concentration…) deviennent des liens. Un toucher ouvre leur fiche du compendium [K4] en feuille modale, sans quitter la fiche.

### 🟠 J9. Les dés : jet simple au MVP (décidé)

**Décision du porteur de projet (25 octobre 2026).** Le MVP propose un jet simple. Le lanceur libre avec historique reste en V2. Les boutons déjà dessinés [C4], [C7], [P12] sont conservés.

**Attendu.**
- Partout où un jet précis est attendu, deux chemins côte à côte : « Saisir mon jet » (dés physiques) et « Lancer » (l'application lance).
- Le jet de l'application connaît sa formule et ses modificateurs : nombre de dés, bonus, Avantage ou Désavantage (deux d20 affichés, le dé écarté barré, comme [C4]), effets reçus (J2, par exemple +1d4 Béni).
- Le résultat s'affiche avec son détail (« d20 15 + 7 = 22 ») et reste modifiable avant validation.
- Concernés au MVP : initiative, jets contre la mort, dés de vie, jets de sauvegarde demandés (J3), soins d'une potion (J4), PV à la montée de niveau en mode jet, jets automatiques des monstres côté MJ.
- Pas de lanceur libre, pas d'historique des jets, pas de jets partagés à la table au MVP : tout cela reste en V2.

---

## 6. Décisions de design à rediscuter

**Décision 1 : la table d'un MJ supprimé reste en place, sans MJ.** Vu de la table, une campagne sans MJ est une impasse : personne ne valide les fiches, ne lance de combat ni n'accorde de niveau. Proposition :
- à la suppression de son compte, le MJ peut transférer la table à un joueur ;
- s'il ne le fait pas, la table passe en lecture seule pour les joueurs (fiches consultables et exportables), et un joueur peut demander à la reprendre comme MJ ;
- le transfert de MJ reste possible à tout moment, sans suppression de compte. Cela prépare le co-MJ prévu plus tard.

**Décision 5 : montée de niveau sans validation du MJ.** Acceptable, puisque la montée n'est possible qu'une fois déverrouillée par la table : seuil de PX atteint ou niveau accordé par le MJ en jalons (voir R2).

---

## 8. Seconde revue (25 octobre 2026, 137 planches)

**Verdict : toutes les demandes de la première revue sont traitées, et bien traitées.** R1 à R5, la planche de données de référence [D1], les écrans F2 à F6 et J1 à J13, et les écrans de compte A1 à A7 sont conformes au cahier et au SRD 5.2.1.

Recalculés et justes : les 7 personnages de [D1] (coût en points, bonus d'Historique, Amélioration du niveau 4, PV, CA, DD, emplacements), les budgets et PX de toutes les rencontres, la mort sur le coup [F2a] (excédent 27 ≥ PV max 27), l'épuisement [F3a]/[F3b] (−4 et −10, Vitesse 6 m et 1,50 m), la magie de pacte [F5a] et le multiclassage Clerc 3 / Paladin 4 [F5b], le délai de réinitialisation et les règles de mot de passe [A2]/[A3].

### Corrections restantes

| # | Gravité | Écran | Constat | Correction |
| --- | --- | --- | --- | --- |
| 1 | 🔴 | [D1], [C3] | Thalia est Criminelle : son don d'origine est **Vigilant**, qui ajoute le bonus de maîtrise à l'initiative. Son initiative est donc **+7** (DEX +4, maîtrise +3), pas +4. [D1] est la source des tests : l'erreur passerait dans les fixtures. | [D1] : initiative +7. [C3] : jet 15 + 7 = 22 ; trouver une autre égalité entre PJ pour illustrer la règle (par exemple Mira et Brannoc). |
| 2 | 🟠 | [D1] | Les dons d'origine et les compétences ne sont détaillés que pour Aldric. C'est ce qui a masqué l'erreur n° 1. | Pour chaque PJ, lister dons (Historique et espèce), compétences maîtrisées et traits d'espèce, comme pour Aldric. Mira : Initié à la magie (Clerc) + don de Polyvalent ; Thalia : Vigilant ; Brannoc : Initié à la magie (Magicien). |
| 3 | 🟠 | [J2], [P14] | Domaine de la Vie, niveau 3 : **Disciple de la Vie** ajoute 2 + niveau de l'emplacement aux soins d'un sort lancé par emplacement. Mot de guérison au 1er niveau soigne 2d4 + 3 + 3, pas 2d4 + 3. | Afficher « 2d4 + 6 PV (dont +3 Disciple de la Vie) » ; même logique pour Soins et Mot de guérison de groupe. Règle à intégrer au moteur (aptitude de type « calculable »). |
| 4 | 🟠 | [J1] | Aldric à 41 / 49 est affiché « Indemne ». Selon EF-TAB-09, indemne = PV au maximum. | « Blessé ». |
| 5 | 🟢 | [G4] | Boule de feu de Brannoc : « DD 14 », alors que [D1] donne DD 15 (INT 18). | DD 15. |
| 6 | 🟢 | [C11] | « Varga · 0 PV au round 5 » alors qu'elle a été assommée [F2b] : 1 PV, Inconsciente. | « Assommée au round 5 (1 PV, Inconsciente) · capturée ». |

Aucune autre remarque : les écrans joueur (vue combat, effets reçus, demandes de jets, jet simple, repos de groupe, suggestions) correspondent exactement aux descriptions des §4 et §5.

---

## 9. Report dans le cahier des charges

Fait le 25 octobre 2026 : les 24 décisions de design et tous les points de cette revue sont intégrés au cahier (§3, §4.1 à §4.4, §5, §6.2 à §6.8, §7, §11, §12, §13). Seule la décision sur le transfert de table (§6 ci-dessus) reste ouverte, en §14.3 du cahier.

Détail :

- Les 24 décisions prises pendant le design (`COMPOSANTS.md` §4) ne sont pas encore dans le cahier : progression en PX ou en jalons, séances et clôture, présences, notes partagées, etc. Elles devront y entrer avant de passer à Claude Code.
- EF-INI-04 (égalités d'initiative) a été corrigé dans le cahier le 25 octobre 2026.
- Les automatismes F2 et F3 sont des exigences de règles : ils iront dans §6.3 du cahier.
- Les points joueur J2 à J7 sont des exigences fonctionnelles nouvelles (§5 et §6 du cahier). J9 (jet simple au MVP) a été ajouté au cahier le 25 octobre 2026.

---

## 10. Revue finale (25 octobre 2026)

Les 6 corrections de la seconde revue (§8) ont toutes été faites :

| # | Planche | Constat |
|---|---|---|
| 1 | [D1], [C3] | Thalia à +7 (DEX +4, maîtrise +3 par Vigilant, don du Criminel), jet 15 → 22. Nouvelle égalité entre PJ à 8 (Brannoc surpris, Désavantage, et Mira) : Sam et Inès choisissent. Égalité entre monstres à 15 : le MJ choisit. Encart Vigilant (échange d'initiative, impossible si Neutralisé) conforme au SRD. |
| 2 | [D1] | Dons, compétences et traits d'espèce détaillés pour les 4 PJ. Aldric : Avantage à l'initiative via Athlète accompli (Champion niv. 3), conforme au SRD. |
| 3 | [J2], [P14], [D1] | Mot de guérison 2d4 + 6, Soins 2d8 + 6, Mot de guérison de groupe 2d4 + 8 (Disciple de la Vie). |
| 4 | [J1] | Aldric 41 / 49 : « Blessé ». |
| 5 | [G4] | Boule de feu de Brannoc : DD 15. |
| 6 | [C11] | Varga « Assommée au round 5 (1 PV, Inconsciente) · capturée ». |

Contrôles croisés sans écart : PX (6 650 + 75 embuscade + 750 relais = 7 475), budget du relais du Sel (3 000 PX = budget Modéré pour 4 PJ niv. 5), 10 / 11 adversaires tombés, DD de Mira (14) et de Brannoc (15), PV de Brannoc (27 avec Ténacité naine).

**Verdict : maquettes validées pour passer à Claude Code.** La décision §14.3 est tranchée (25 octobre 2026) : si le MJ supprime son compte, la table continue d'exister sans MJ et ses fiches ne sont plus modifiables.
