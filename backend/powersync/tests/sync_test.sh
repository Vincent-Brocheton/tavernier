#!/usr/bin/env bash
# Spec sync-backend : « Règles de synchronisation ». Un MJ, deux joueurs et un
# inconnu, avec de vrais comptes Supabase Auth ; chacun lit son flux PowerSync
# jusqu'au premier checkpoint complet, comparé à ce que son rôle doit recevoir.
#
# Prérequis : Supabase local démarré (depuis backend/), PowerSync sur
# $POWERSYNC_URL (http://localhost:8080 par défaut), curl, jq, docker.
set -euo pipefail
cd "$(dirname "$0")/../.."

POWERSYNC_URL=${POWERSYNC_URL:-http://localhost:8080}
eval "$(supabase status -o env | grep -E '^(API_URL|ANON_KEY|SERVICE_ROLE_KEY)=')"

sql() { docker exec -i supabase_db_tavernier psql -U postgres -v ON_ERROR_STOP=1 -qtA "$@"; }

# Comptes ----------------------------------------------------------------------

declare -A id token
for who in mj joueur1 joueur2 inconnu; do
  id[$who]=$(curl -sf "$API_URL/auth/v1/admin/users" \
    -H "apikey: $SERVICE_ROLE_KEY" -H "Authorization: Bearer $SERVICE_ROLE_KEY" \
    -H 'Content-Type: application/json' \
    -d "{\"email\":\"$who@test.local\",\"password\":\"mot-de-passe-$who\",\"email_confirm\":true,\"user_metadata\":{\"pseudonym\":\"$who\",\"birth_date\":\"2000-01-01\"}}" |
    jq -r .id)
  token[$who]=$(curl -sf "$API_URL/auth/v1/token?grant_type=password" \
    -H "apikey: $ANON_KEY" -H 'Content-Type: application/json' \
    -d "{\"email\":\"$who@test.local\",\"password\":\"mot-de-passe-$who\"}" |
    jq -r .access_token)
done

# Données : la table du MJ, deux joueurs et leurs fiches ----------------------

# Les profils sont créés à l'inscription (US-12).
sql <<SQL
insert into game_table (id, gm_user_id, name, stat_method, long_rest_rule,
  hp_on_level_rule, progression_mode)
  values ('t1', '${id[mj]}', 'Brumeval', 'point_buy', 'full', 'average', 'xp');
insert into table_member (id, table_id, user_id, role) values
  ('m0', 't1', '${id[mj]}', 'gm'),
  ('m1', 't1', '${id[joueur1]}', 'player'),
  ('m2', 't1', '${id[joueur2]}', 'player');
insert into table_invite (id, table_id, code, expires_at)
  values ('i1', 't1', 'ABC123', now() + interval '7 days');
insert into table_pack (id, table_id, pack_id) values ('p1', 't1', 'srd');
insert into character (id, table_id, owner_user_id, kind, name, species_id,
  background_id, status) values
  ('c1', 't1', '${id[joueur1]}', 'pc', 'Brunhild', 'srd:species:dwarf',
   'srd:background:criminal', 'active'),
  ('c2', 't1', '${id[joueur2]}', 'pc', 'Mira', 'srd:species:elf',
   'srd:background:sage', 'active');
insert into character_state (id, character_id) values ('s1', 'c1'), ('s2', 'c2');
insert into character_item (id, character_id, item_id, quantity, equipped,
  attuned, position) values ('o1', 'c1', 'srd:item:rope', 1, false, false, 0);
SQL

# Flux ---------------------------------------------------------------------------

# Les lignes reçues, « type/id » triés, jusqu'au premier checkpoint complet.
received() {
  curl -sN --max-time 20 "$POWERSYNC_URL/sync/stream" \
    -H "Authorization: Bearer ${token[$1]}" -H 'Content-Type: application/json' \
    -d '{"raw_data":true,"include_checksum":true,"streams":{"include_defaults":true,"subscriptions":[]}}' |
    sed '/checkpoint_complete/q' |
    jq -r 'select(.data) | .data.data[] | select(.op == "PUT") | "\(.object_type)/\(.object_id)"' |
    sort -u || true
}

failures=0
expect() {
  local who=$1 label=$2; shift 2
  local want got
  want=$(printf '%s\n' "$@" | sort -u)
  # La réplication est asynchrone : on attend qu'elle rattrape les données.
  for _ in $(seq 30); do
    got=$(received "$who")
    [ "$got" = "$want" ] && break
    sleep 2
  done
  if [ "$got" = "$want" ]; then
    echo "ok - $label"
  else
    echo "not ok - $label"
    diff <(echo "$want") <(echo "$got") | sed 's/^/    /' || true
    failures=$((failures + 1))
  fi
}

profiles=("profile/${id[mj]}" "profile/${id[joueur1]}" "profile/${id[joueur2]}")
table=(game_table/t1 table_member/m0 table_member/m1 table_member/m2 table_pack/p1)
c1=(character/c1 character_state/s1 character_item/o1)
c2=(character/c2 character_state/s2)

expect mj "le MJ reçoit sa table, ses invitations et toutes les fiches" \
  "${profiles[@]}" "${table[@]}" table_invite/i1 "${c1[@]}" "${c2[@]}"
expect joueur1 "un joueur reçoit sa table et sa fiche, pas celle des autres" \
  "${profiles[@]}" "${table[@]}" "${c1[@]}"
expect joueur2 "l'autre joueur reçoit sa seule fiche" \
  "${profiles[@]}" "${table[@]}" "${c2[@]}"
expect inconnu "un inconnu ne reçoit que son profil" "profile/${id[inconnu]}"

sql -c "update game_table set full_sheets_visible = true where id = 't1'"
expect joueur2 "fiches visibles : un membre reçoit les fiches des autres" \
  "${profiles[@]}" "${table[@]}" "${c1[@]}" "${c2[@]}"

[ "$failures" -eq 0 ] || { echo "$failures échec(s)"; exit 1; }
