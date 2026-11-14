## Context

Plusieurs pièces existent déjà :
- **`NpcStore`** (lot a) : il crée, modifie, duplique et liste les PNJ.
- **Contenu actif** (`contentProvider`) : il porte les monstres en `MonsterData`. Ce sont des profils recopiés tels qu'imprimés, avec les noms des compétences, des types de dégâts et des états. Le texte de chaque action est complet ; seuls son nom et son usage sont à part.
- **Rendu d'un profil** : aucun écran n'en affiche encore.

## Decisions

- **`StatBlockView(monster, name, base)`** (app, `npcs/stat_block_view.dart`) : une vue en lecture seule qui ne recalcule rien. Chaque ligne reprend la forme du SRD français :
  - **Type** : `Humanoïde de taille M ou P, Neutre`, avec les tailles TP, P, M, G, TG et Gig. Pour une nuée : `Nuée de taille M de Bêtes de taille TP`. Les étiquettes de type vont entre parenthèses.
  - **Valeurs** :
    - Initiative `+3 (13)` (10 + bonus) ;
    - PV `52 (8d8 + 16)` ;
    - Vitesse `9 m, nage 9 m, vol 18 m (vol stationnaire)` avec `formatFeet`, puis `speedNote` ;
    - FP `2 (450 PX ; BM +2)`, ou `10 (5 900 PX, ou 7 200 dans son antre ; BM +4)`.
  - **Sens** : `Vision aveugle 3 m, Vision dans le noir 18 m ; Perception passive 10`, avec « Vision lucide » et « Perception des vibrations ».
  - **Usages** : `(recharge 5–6)`, `(2/jour)`, `(3/jour, ou 4/jour dans son antre)`, `(recharge après un Repos court ou long)`.
  - **Catégories d'actions** : « Traits », « Actions », « Actions Bonus », « Réactions », « Actions légendaires ».

  Les libellés fixes vont dans l'ARB. Les noms de compétences, de dégâts et d'états viennent du contenu (`namesOf`).
- **Monstre de départ** : `Npc.monsterId`, résolu dans le contenu actif. Un monstre absent (pack désactivé) affiche « Monstre introuvable : <id> », sans erreur.
- **Pack et version** : « Variante de « Chef de bande » · SRD 5.2.1 ». Le pack vient de `content.packs` (manifeste, nom, version), qui contient l'entité.
- **Choix du monstre** : une feuille avec un champ de recherche, filtrée sans tenir compte des accents ni de la casse. Chaque ligne affiche « FP n · pack ». La liste est limitée à 50 lignes ; la recherche affine.
- **Attitude** : `SegmentedButton<Attitude>` qui écrit dès le choix. Les libellés du SRD sont « Amical », « Indifférent » et « Hostile », et chaque libellé a son icône.
- **Onglet** : il est inséré après « Séances » pour le MJ seul, ce qui lui donne cinq onglets ; le joueur garde les trois siens.
- **Routes** : `/tables/:id/pnj/nouveau` et `/tables/:id/pnj/:npc`.

## Risks / Trade-offs

- **Bloc modifié** : `statBlock` (JSON) n'est pas lu à l'affichage. Aucun écran ne l'écrit encore ; l'éditeur le fusionnera au monstre.
- **Grand bestiaire** : la limite de 50 lignes demande de chercher pour trouver un monstre rare. La recherche est le chemin prévu par [G5].
