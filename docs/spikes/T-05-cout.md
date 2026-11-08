# T-05 — Coût estimé pour 1 000 utilisateurs

Critère de la carte T-05 (cahier §14.1, risque « Coûts serveur d'une application gratuite avec comptes »). Estimation du 8 novembre 2026, avec les grilles publiques de Supabase et de PowerSync Cloud à cette date.

## Volume mesuré

Mesure faite sur la base PowerSync de l'app (`dnd_data`) avec la fixture Aldric [D1] :

| Écriture | Opérations envoyées | Octets |
|---|---|---|
| Création d'une fiche niveau 1 (Guerrier) | 26 | 6 261 |
| Changement de PV | 1 | 107 |

Une fiche niveau 5 de lanceur de sorts, avec ses sorts et son inventaire, est estimée à **20 Ko** au plus. Grâce à l'enregistrement par différence (t-05d), une modification n'envoie que les lignes et les colonnes qui changent.

## Hypothèses

- **1 000 comptes**, chacun avec 3 fiches en moyenne. Tables de 5 membres, avec un MJ pour 4 joueurs.
- **Activité :** une séance par semaine, soit 4 par mois. Pendant une séance, 200 petites écritures par joueur (PV, ressources, état), reçues par les 5 membres de la table.
- **Nouvelles installations :** 4 synchronisations complètes par mois et par compte (nouvel appareil, navigateur vidé), soit 100 Ko chacune.
- **Pic d'usage :** les séances se concentrent le soir et le week-end, avec **20 % des comptes connectés en même temps**, soit 200 clients.

## Estimation

| Poste | Calcul | Total |
|---|---|---|
| Base Supabase | 1 000 × 3 fiches × 20 Ko, ×3 pour les index et l'historique | ≈ 180 Mo |
| Données hébergées par PowerSync | ≈ 100 Ko par compte (ses fiches, plus celles de sa table pour le MJ) | ≈ 100 Mo |
| Données synchronisées par mois | séances 4 × 200 × 110 o × 5 ≈ 0,45 Mo, plus 4 × 100 Ko ≈ 0,4 Mo, par compte | ≈ 0,9 Go |
| Utilisateurs actifs (Supabase Auth) | 1 000 | 1 000 MAU |
| Clients simultanés au pic (PowerSync) | 20 % de 1 000 | ≈ 200 |

## Grilles (8 novembre 2026)

| | Gratuit | Payant |
|---|---|---|
| **Supabase** | 0 $ : 500 Mo de base, 50 000 MAU, 5 Go de sortie, **mise en pause après 1 semaine d'inactivité** | Pro, 25 $/mois : 8 Go, 100 000 MAU, 250 Go de sortie |
| **PowerSync Cloud** | 0 $ : 2 Go synchronisés/mois, 500 Mo hébergés, **50 clients simultanés**, désactivé après inactivité | Pro, 49 $/mois : 30 Go synchronisés, 10 Go hébergés, 1 000 clients simultanés |

Sources : https://supabase.com/pricing, https://www.powersync.com/pricing.

## Conclusion

- **Le volume n'est pas le problème.** À 1 000 comptes, la base, les données hébergées et les données synchronisées tiennent dans les paliers gratuits, avec une large marge.
- **La limite, ce sont les connexions simultanées.** PowerSync gratuit en accepte 50, alors que le pic estimé est d'environ 200. Les paliers gratuits mettent aussi en pause un projet inactif.
- **En production :** Supabase Pro (25 $) et PowerSync Pro (49 $), soit **≈ 74 $ par mois** pour 1 000 utilisateurs (≈ 0,07 $ par utilisateur). Avec ces deux paliers, on reste dans les quotas jusqu'à environ 5 000 comptes, puisque le pic passerait à 1 000 clients simultanés. Au-delà, PowerSync facture 30 $ par tranche de 1 000 clients simultanés supplémentaires.
- **En développement et en bêta fermée** (moins de 50 joueurs connectés à la fois) : les paliers gratuits suffisent. Le projet se met en pause après une semaine sans activité ; il suffit de le relancer depuis le tableau de bord.
- **Suivi** (cahier §14.1) : relever chaque mois les clients simultanés au pic et les données synchronisées dans le tableau de bord PowerSync, avec une alerte à 80 % du palier.
