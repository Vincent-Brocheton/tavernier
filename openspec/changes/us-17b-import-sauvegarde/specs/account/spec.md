## ADDED Requirements

### Requirement: Importer une sauvegarde
« Mes données » SHALL proposer « Importer une sauvegarde » (ENF-12). Après le choix d'un fichier, une confirmation SHALL dire que les éléments absents de l'appareil seront ajoutés et que ceux déjà présents seront gardés. Une fois l'import fait, l'app SHALL afficher le nombre d'éléments ajoutés et déjà présents. Un fichier refusé SHALL être signalé, sans rien changer.

#### Scenario: Import confirmé
- **WHEN** l'utilisateur choisit un export puis confirme
- **THEN** les éléments manquants sont ajoutés et l'app affiche combien l'ont été

#### Scenario: Import annulé
- **WHEN** l'utilisateur ferme le choix du fichier ou annule la confirmation
- **THEN** rien n'est importé

#### Scenario: Fichier refusé
- **WHEN** le fichier choisi n'est pas un export de Tavernier
- **THEN** un message le dit et rien n'est importé
