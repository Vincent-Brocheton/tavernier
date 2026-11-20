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

### Lot b : Espèce, Sort, Objet, variantes

- **Éditeur d'effets** : les opérations à structure imbriquée du DSL v1.
- **Espèce** : taille, vitesse, traits, sous-lignées, sans bonus de caractéristique.
- **Sort** : niveau, école, incantation, portée, composantes, durée, concentration, listes de classes et effets à niveau supérieur.
- **Objet ([H05])** : type, rareté, harmonisation, propriétés, CA ; une arme a toujours une botte.
- **Variante d'une entité SRD (EF-HB-02)** : copie de l'entité dans le pack, sous un nouvel identifiant ; l'original n'est pas modifié.

### Lot c : Classe et Sous-classe

- **Classe** : dé de vie, caractéristique principale, maîtrises, progression de 1 à 20, nombre de bottes, incantation, sous-classe au niveau 3.
- **Sous-classe ([H02])** : classe parente, et aptitudes par niveau, alignées sur les niveaux de sous-classe de la classe parente.
- **Progression incomplète (EF-HB-11)** : elle bloque la publication, pas le test.

### Lot d : Monstre

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

- **`dnd_content`** : réutilise les modèles, `validatePack` et `validateEffect`, sans changer le format.
- **`dnd_data`** : table, migration v6, `HomebrewStore`.
- **App** : `lib/homebrew/` (nouveau), et l'onglet Homebrew de `main.dart`.

## Hors périmètre

- **Tester une entité sur un personnage** ([H04]) : US-28.
- **Publier et exporter un pack signé** ([H06]) : US-29.
- **Importer, dupliquer et activer un pack** ([H08] à [H11]) : US-30.
- **Opérations hors du DSL v1** : un changement du DSL à part.
