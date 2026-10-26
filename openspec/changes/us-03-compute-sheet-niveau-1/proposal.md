# Proposal

## Why

Le critère de sortie de M0 (cahier §3) exige un PJ de niveau 1 créé et validé en test unitaire, sans UI : la fiche d'Aldric niveau 1 recalculée par `computeSheet()` doit être identique à la fixture [D1]. Le moteur de règles `dnd_rules` est encore vide ; c'est lui qui portera toutes les valeurs de la fiche (EF-PJ-02) et leur décomposition (EF-PJ-03).

Carte Trello : [US-03 · computeSheet() : fiche de niveau 1](https://trello.com/c/Ncrb7VDK/25-us-03-computesheet-fiche-de-niveau-1). Exigences : US-03, EF-PJ-02, EF-PJ-03, cahier §10.3, §11.3, §12.1.

## What Changes

- `computeSheet(personnage, contenu actif) → fiche calculée`, fonction pure de `dnd_rules` (ni base, ni réseau, ni Flutter), pour un personnage de niveau 1 dans une seule classe.
- Valeurs calculées : valeurs et modificateurs de caractéristique, bonus de maîtrise, jets de sauvegarde, 18 compétences, Perception passive, Initiative (bonus et Avantage), CA, vitesse, PV maximum, dés de vie, emplacements de bottes, attaques (bonus, dégâts, type, portée, botte), ressources.
- Décomposition de chaque valeur calculée en contributions `{source, valeur}` (EF-PJ-03).
- Interprétation des opérations du DSL v1 utilisées au niveau 1 : `modify_ac`, `modify_initiative`, `grant_resource`, `grant_mastery_slots`, `grant_feat`, `grant_proficiency`, `choice`. Les autres opérations du DSL sont acceptées et sans effet sur la fiche (elles ne servent à aucune entité de l'échantillon M0).
- Contrôles d'intégrité du cahier §11.3, rendus comme une liste d'erreurs (jamais une exception) : bonus d'Historique, don d'origine, bottes, prérequis de multiclassage. Plus les règles de génération des valeurs du SRD (acquisition par points à 27 points, valeurs standard).
- Les fixtures [D1] actives deviennent le test de référence : Aldric niveau 1 doit être reproduit à l'identique. Le format d'entrée de la fixture est aligné sur le DSL (choix stockés par identifiant de choix, ressource « Inspiration héroïque » nommée par sa clé `srd:resource:heroic-inspiration`) ; **aucune valeur attendue ne change**.
- Le contrôle de couverture de la CI refuse désormais un rapport vide (constat reporté de la revue de US-01).

Hors périmètre :
- Niveaux 2 à 20, montée de niveau, sous-classe, Amélioration de caractéristique : M1 (US-08). La fixture `aldric_n5` reste `pending_engine`.
- Sorts, emplacements, incantation, concentration en jeu : M1 (US-09). La règle §11.3 « un seul sort à concentration » est garantie par le modèle d'état (un seul champ) et sera testée avec le suivi de jeu en US-09.
- Inventaire complet, harmonisation, monnaie : M1 (US-10). Ici, seuls les objets équipés et les armes portées comptent.
- Langues et équipement de départ (création guidée) : M1 (US-05).
- Classes autres que le Guerrier : leur contenu arrive en M1 ; Mira, Thalia, Brannoc et Kael restent `pending_content`.

## Capabilities

### New Capabilities
- `character-sheet`: calcul de la fiche d'un personnage à partir de ses choix stockés et du contenu actif, avec la décomposition de chaque valeur et les contrôles d'intégrité des règles 2024.

### Modified Capabilities
_(aucune : aucune spec n'existe encore)_

## Impact

- `packages/dnd_rules` : nouveau code (modèle d'entrée du personnage, fiche calculée, interpréteur des effets, contrôles), dépendance à `dnd_content` ; dépendance de test à `srd_builder` pour charger le pack SRD réel depuis ses sources.
- `packages/dnd_rules/test/fixtures/d1/aldric_n1.json` (format d'entrée seulement) et le test qui compare les fixtures actives.
- `tool/check_coverage.dart` : échec sur un rapport de couverture vide.
- Aucun changement de format de pack ni de DSL ; aucune UI.
- Écarts [D1] / SRD : aucun nouveau. Les choix non précisés par [D1] pour Aldric niveau 1 (bottes, boîte de jeux, équipement) ont été validés par le porteur de projet le 25 octobre 2026.
