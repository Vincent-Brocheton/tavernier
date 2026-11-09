## ADDED Requirements

### Requirement: Sessions du compte
Un utilisateur SHALL lister ses seules sessions, et SHALL révoquer toute autre de ses sessions que celle en cours ; jamais celle d'un autre utilisateur.

#### Scenario: Liste
- **WHEN** un utilisateur liste ses sessions
- **THEN** il ne voit que les siennes, et celle en cours est signalée

#### Scenario: Révocation
- **WHEN** il révoque une autre de ses sessions
- **THEN** elle est supprimée

#### Scenario: Session d'un autre
- **WHEN** il tente de révoquer la session d'un autre utilisateur
- **THEN** rien n'est supprimé
