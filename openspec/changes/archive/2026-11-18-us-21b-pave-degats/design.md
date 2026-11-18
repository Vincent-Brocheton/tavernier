## Context

Le moteur (lot a) applique `damage`, `heal`, `temp_hp` et `death_save`, et `resolveDamage` donne l'aperçu. L'écran de combat (US-20) liste des `_CombatantCard` : les toucher ouvrait le détail.

## Decisions

- **Cibles** : un état de `CombatView` (ensemble d'identifiants), gardé tant que l'écran vit. Toucher remplace les cibles par la carte touchée, un appui long l'ajoute ou la retire. Une cible retirée du combat sort de l'ensemble.
- **Pied** : en `bottomNavigationBar` sur deux lignes, d'abord « Cible : … », puis les trois boutons et « Tour suivant ». Sans cible, les trois boutons sont désactivés.
- **`DamageKeypad`** (`showDamageKeypad(context, encounter, targets, mode)`) :
  - **Saisie** : une liste de termes signés. « + » et « − » ouvrent un nouveau terme, et le montant est leur somme, au moins 0 ;
  - **Mode** : dégâts, soins ou PV temporaires ; « Soins » et « PV temp. » basculent le mode. Le type de dégâts est retenu dès le premier choix ;
  - **Défaut** : sans type choisi, « Tranchants ». C'est le type affiché, et il s'applique sans défense.
  - **Aperçu** : `resolveDamage` sur l'état projeté de chaque cible, ou `min(hp + montant, max)` pour un soin ;
  - **« Appliquer »** écrit un seul événement pour toutes les cibles, puis ferme le pavé.
- **Barre de PV** : `HpBar` local à l'app, avec le remplissage à seuils de §2.2 (> 50 % soins, > 25 % alerte, sinon dégâts), et dans l'aperçu la portion perdue dans une teinte atténuée.
- **Jets contre la mort** :
  - sur la carte, 3 cercles (réussites, `heal`) et 3 carrés (échecs, `damage`), avec une icône en plus de la couleur ;
  - dans la feuille, quatre boutons qui écrivent `death_save`.

## Risks / Trade-offs

- **Hachures de la portion perdue** ([1b]) : remplacées par une teinte atténuée, plus simple et lisible. L'information est aussi portée par les nombres « 22 → 10 ».
- **Type de dégâts par défaut** : sur une cible résistante aux dégâts tranchants, oublier de choisir le type applique la Résistance. Le type affiché en grand le rend visible.
