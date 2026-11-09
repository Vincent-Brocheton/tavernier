# Design

## Décisions

1. **Réglages de l'appareil** dans `shared_preferences` (déjà tiré par `supabase_flutter`), lus avant le premier affichage. La taille du texte dépend de l'écran et le consentement de l'appareil : rien n'est synchronisé.
2. **Taille du texte** : l'échelle du système est multipliée par le réglage, puis bornée entre 85 % et 200 % (`AppTextScale`, tokens).
3. **Consentement absent = pas encore demandé** (`null`). Le dialogue [T1] s'ouvre une fois, à l'accueil, et ne se ferme qu'avec une réponse. Le refus est la valeur sûre.
4. **Déconnexion :**
   - si la file d'envoi n'est pas vide, une confirmation avec le nombre de modifications ;
   - puis `disconnectAndClear()` de PowerSync, qui efface les tables synchronisées et la file ;
   - puis `signOut()` de Supabase, sur cet appareil seulement.
   Le contenu de règles (packs) reste.
5. **Desktop [A7]** : à gauche, la liste des sections de ce lot (Affichage, Confidentialité, Se déconnecter) ; à droite, l'en-tête du profil et la section choisie. **Téléphone [T5]** : tout en une colonne.

## Risques

- **Modifications perdues à la déconnexion** si l'utilisateur confirme sans réseau. C'est voulu : la confirmation le dit.
