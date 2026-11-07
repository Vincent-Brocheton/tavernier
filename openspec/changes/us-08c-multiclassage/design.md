# Design

## Contexte

`computeSheet` sait déjà compter les PV d'une seconde classe et signaler un prérequis manquant. `levelGain` et `applyLevelUp` supposent en revanche que la classe existe sur le personnage.

## Décisions

1. **Bloc `multiclass`.** Armes, armures, outils d'office, nombre de compétences et d'instruments. Le dé de vie et les listes de choix restent ceux de la classe. Un pack sans ce bloc n'accorde que le dé de vie.
2. **Compétence et instrument, des `OpenChoice`.** `levelGain` les ajoute à ses choix : validation et écran existent déjà. `applyLevelUp` range la compétence dans `ClassLevelInput.skillChoices`, seule source lue par le moteur.
3. **Outils.** Le moteur ne les calcule pas encore. L'instrument reste dans `choices`, sous une clé par classe pour ne pas écraser celui de la création.
4. **`classAccess`.** Le contrôle d'intégrité et l'écran partagent le même calcul.
5. **`ComputedSheet.proficientWeapons`.** L'assistant ne propose en bottes que des armes maîtrisées : un Magicien qui prend Roublard n'a pas les armes de guerre du Roublard.
6. **Dés de vie.** `hitDice` devient une liste par type, dans l'ordre des classes. Le format JSON des fixtures suit, leurs valeurs ne bougent pas.
7. **`ac_formula`.** La meilleure formule valide s'applique, si elle bat 10 + DEX. Le SRD laisse le joueur choisir : la meilleure est celle qu'il choisirait, et l'écran n'a pas de choix à proposer.

## Risques

- **Colonne ajoutée au schéma v1 :** non publié, régénéré.
