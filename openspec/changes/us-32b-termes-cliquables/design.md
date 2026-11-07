# Design

## Contexte

Les états sont déjà des entités avec leur texte. Les autres termes du glossaire n'existent pas dans le pack.

## Décisions

1. **Type `rule`.** Une entité par terme, sans données, avec le texte obligatoire. Une table de plus, comme `condition`.
2. **Texte recopié du SRD.** Aucune traduction. Un test retrouve la première phrase de chaque terme dans `docs/srd/FR_SRD_CC_v5.2.1.txt`.
3. **Repérage sensible à la casse.** « Avantage » est le terme du SRD, « avantage » un nom commun. Un nom de plusieurs mots accepte aussi sa minuscule initiale (« action Bonus »).
4. **Limites de mot Unicode.** « Réaction » ne doit pas s'allumer dans un autre mot.
5. **`WidgetSpan`.** Chaque terme porte sa sémantique de lien (« Désavantage, définition »). Le plus long nom gagne.
6. **Expression régulière mise en cache par contenu**, comme `sortedEntities`.

## Risques

- **Colonne de table ajoutée au schéma v1 :** non publié, base locale de test à effacer.
