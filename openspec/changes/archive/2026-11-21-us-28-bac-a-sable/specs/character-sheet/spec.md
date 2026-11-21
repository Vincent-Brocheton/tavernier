## ADDED Requirements

### Requirement: Prétiré de test
`sandboxCharacter` SHALL construire un personnage valide à partir du contenu : une classe à un niveau, la sous-classe dès son niveau, une espèce et un Historique (Humain et Soldat par défaut). Ses valeurs suivent les suggestions de la création :
- le tableau standard de la classe ;
- les bonus d'Historique en 2-1 ;
- les compétences de la classe, celles des caractéristiques principales d'abord ;
- le don d'origine de l'Historique ;
- l'option A d'équipement de départ, avec la première armure et la première arme portées.

Il SHALL pouvoir recevoir un bouclier porté, des dons et des objets en plus.

#### Scenario: Guerrier prétiré
- **WHEN** un Guerrier prétiré de niveau 7 est construit avec un bouclier
- **THEN** il est Humain et Soldat, porte la cotte de mailles et le bouclier, et sa fiche se calcule avec une CA de 18

### Requirement: Comparaison de deux fiches
`compareSheets` SHALL rendre les lignes de [H04] entre une fiche sans l'entité et une fiche avec elle :
- toujours : CA, PV max, Initiative, Vitesse, Perception passive, et chaque attaque ;
- si leur valeur change : chaque JS, chaque compétence, chaque ressource, la Vision dans le noir, les attaques par action et les emplacements de sorts.

Chaque ligne SHALL porter la valeur sans, la valeur avec, et les sources de la valeur avec qui n'étaient pas dans la valeur sans. Sans fiche « sans », la valeur sans SHALL être absente. Les règles enfreintes ajoutées par l'entité SHALL être rendues à part.

#### Scenario: Don qui donne +1 CA
- **WHEN** on compare un prétiré sans puis avec un don qui donne +1 CA
- **THEN** la ligne de CA passe de la valeur sans à la valeur plus 1, avec pour source le don, et les lignes des JS, inchangées, n'apparaissent pas
