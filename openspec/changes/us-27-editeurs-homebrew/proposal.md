# Proposal

## Why

Carte Trello [US-27](https://trello.com/c/ak3OW87y) : les éditeurs homebrew des 8 types d'entités. Exigences : **EF-HB-01**, **EF-HB-02** et **EF-HB-11** ; cahier §7.1 et §7.2 ; planches [H01], [H02], [H03] et [H05].

Tout contenu de règles vit dans un pack, et le homebrew passe par les mêmes validations que le SRD (`validatePack`, `validateEffect`). Il manque l'endroit où l'on crée un pack et ses entités : l'onglet Homebrew est encore vide.

Décisions du porteur de projet du 20 novembre 2026 :
- **Brouillons dans une table locale** (`homebrew_draft`, schéma v6, non synchronisée) qui garde le pack entier en JSON, même incomplet. Il n'entre dans les tables de contenu qu'au test (US-28) ou à la publication (US-29). Le format `.dndpack` ne change pas.
- **L'éditeur d'effets ne propose que les opérations du DSL v1** (`docs/dsl/DSL_V1.md`). Ce qui en sort reste dans le texte de l'aptitude, que le joueur lit, comme pour le SRD. La réaction à déclencheur de [H03] est donc décrite dans le texte, sans effet mécanique.
- **Livraison en quatre lots** : les packs et les types simples d'abord.

## What Changes

### Lot a : packs, effets, Don et Historique

- **Base locale** : la table `homebrew_draft` (`id`, `pack` en JSON, `updated_at`), au schéma v6, et `HomebrewStore` pour créer, enregistrer, lister et supprimer un brouillon.
- **Onglet Homebrew ([H01])** :
  - « Mes packs » : les brouillons, avec leur version, leur contenu et leur état de vérification ;
  - « Inclus » : le SRD 5.2.1, verrouillé ;
  - « Nouveau pack » : nom, espace de noms, version 0.1.0, licence, auteur ;
  - « Créer une entité » : les 8 types. Les types des lots suivants sont désactivés jusqu'à leur livraison.
- **Page d'un pack** : ses entités par type, « Ajouter une entité » et le panneau « Vérification ». Il porte les problèmes de `validatePack` (bloquants pour publier) et ceux du lot propre à chaque type.
- **Éditeur d'effets ([H03])** : la liste fermée du DSL v1, chaque opération par un formulaire guidé, et l'aperçu « Ce que le joueur lira ».
  - Au lot a, les dix opérations à champs simples : caractéristique, maîtrise, Expertise, CA (avec sa condition d'armure ou de bouclier), Vitesse, PV maximum, sens, résistance ou immunité, Initiative, Avantage.
  - Celles à structure imbriquée (choix, ressource à utilisations, sort accordé, valeur par niveau, don accordé…) suivent au lot b.
- **Don** : catégorie obligatoire, prérequis, répétable, effets.
- **Historique** : exactement 3 caractéristiques, un don de catégorie origine, 2 compétences, un outil, l'équipement et l'or.

### Lot b : Sort, Objet, variantes ; puis Espèce et opérations imbriquées

Décisions du porteur de projet du 21 novembre 2026 (format `.dndpack`, ajouts facultatifs) :
- **Arme ou armure magique** : `weapon` et `armor` reçoivent `rarity` et `attunement`, facultatifs. Une variante garde son type, avec `extends_id`. Avec une rareté, elle est magique : le moteur applique ses effets quand elle est équipée, et harmonisée si elle le demande, comme pour un objet magique. [H05] est suivi à la lettre.
- **Listes de classes d'un sort** : `spell` reçoit `classes`, facultatif. La liste d'une classe devient celle de la classe, suivie des sorts actifs qui la citent. Le SRD ne change pas : sa classe porte sa liste.

Le lot b se livre en deux PR :
- **b1** :
  - **Format** : les champs ci-dessus, et la base locale v7 qui les garde (colonnes facultatives de `weapon`, `armor` et `spell`).
  - **Sort** : niveau, école, incantation, rituel, portée, composantes, durée, concentration, listes de classes. Les effets à niveau supérieur restent dans le texte, comme au SRD.
  - **Objet ([H05])** : arme, armure, objet magique ou objet courant.
    - Une arme a toujours une botte.
    - La rareté et l'harmonisation rendent magique une arme ou une armure : ses effets s'appliquent alors.
    - Le DSL v1 ne calcule pas un bonus aux jets d'attaque et de dégâts propre à une arme : il s'écrit dans le texte.
  - **Variante d'une entité SRD (EF-HB-02)** : la copie entre dans le pack avec un nouvel identifiant et `extends_id` ; l'original n'est pas modifié.
- **b2** :
  - **Espèce** : taille, vitesse et traits, sans bonus de caractéristique. Chaque trait est une entité `feature` du pack ; une sous-lignée est un trait à choix, comme le Lignage elfique du SRD.
  - **Éditeur d'effets** : les opérations à structure imbriquée du DSL v1.

### Lot c : Classe et Sous-classe

Décisions du porteur de projet du 21 novembre 2026 :
- **Niveaux de sous-classe** : `class` reçoit `subclass_feature_levels`, facultatif (format `.dndpack`, base locale v8). Ce sont les niveaux où la sous-classe accorde ses aptitudes (Guerrier : 3, 7, 10, 15, 18). L'extracteur les lit dans les lignes « Aptitude de sous-classe » de la table du SRD. Un pack antérieur se lit sans eux.
- **Éditeur de Classe complet** : incantation et multiclassage compris. L'équipement de départ se réduit à l'or.

- **Classe** : dé de vie, caractéristique principale, maîtrises, progression de 1 à 20, colonnes de la table (bottes, emplacements…), incantation, niveau et niveaux de sous-classe.
- **Sous-classe ([H02])** : classe parente, et aptitudes par niveau, alignées sur les niveaux de sous-classe de la classe parente.
- **Progression incomplète (EF-HB-11)** : elle bloque la publication, pas le test.

### Lot d : Monstre

Décisions du porteur de projet du 21 novembre 2026 :
- **Paliers d'Étude dans le format** : `monster` reçoit `study_reveals` (`[{dc, text}]`), facultatif, indexé dans la table `study_reveal` du cahier §11, qui existe déjà : pas de migration. Un PNJ créé depuis le monstre les reçoit en informations cachées, et l'assistant d'Étude les lit pour un monstre sans PNJ.
- **CA calculée par l'éditeur seul** : le format ne change pas. L'éditeur écrit `ac` et la formule dans `ac_note` (« Armure de cuir clouté, Bouclier ») ; une CA naturelle garde son libellé dans `ac_note`.

Le bloc de stats complet :
- type, FP et PX, actions et légendaires ;
- informations d'Étude par palier ;
- Intelligence obligatoire ;
- CA calculée depuis l'armure et le bouclier, avec sa formule affichée, ou CA naturelle avec un libellé.

## Capabilities

### New Capabilities

- `homebrew` : brouillons de packs et éditeurs d'entités.

### Modified Capabilities

- `local-database` : schéma v6, `homebrew_draft`.

## Impact

- **`dnd_content`** : réutilise les modèles, `validatePack` et `validateEffect`. Le lot b ajoute au format `rarity` et `attunement` (arme, armure) et `classes` (sort), tous facultatifs.
- **`dnd_rules`** : effets d'un objet équipé, `ActiveContent.spellList` (lot b).
- **`dnd_data`** : table, migration v6, `HomebrewStore` ; colonnes v7 (lot b).
- **App** : `lib/homebrew/` (nouveau), et l'onglet Homebrew de `main.dart`.

## Hors périmètre

- **Tester une entité sur un personnage** ([H04]) : US-28.
- **Publier et exporter un pack signé** ([H06]) : US-29.
- **Importer, dupliquer et activer un pack** ([H08] à [H11]) : US-30.
- **Opérations hors du DSL v1** : un changement du DSL à part.
