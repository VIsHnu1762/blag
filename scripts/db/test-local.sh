#!/usr/bin/env bash
# Run all migrations and pgTAP tests on a plain local Postgres, without Docker
# or the Supabase CLI. The real check in CI is `supabase test db`.
#
# Needs: psql pointing at a server you can create databases on (PG* env vars),
# and pgTAP's SQL file: PGTAP_SQL=/path/to/pgtap.sql (built from
# https://github.com/theory/pgtap: sed the MODULE_PATHNAME/__VERSION__ markers
# in sql/pgtap.sql.in, or install the pgtap extension and leave PGTAP_SQL unset).
set -euo pipefail
cd "$(dirname "$0")/../.."

DB="${BLAG_TEST_DB:-blag_test}"
psql -q -X -d postgres -c "drop database if exists $DB" -c "create database $DB"
P=(psql -q -X -v ON_ERROR_STOP=1 -d "$DB")

"${P[@]}" -f scripts/db/supabase-stubs.sql
if [[ -n "${PGTAP_SQL:-}" ]]; then
  "${P[@]}" -c "set search_path = extensions" -f "$PGTAP_SQL" >/dev/null
else
  "${P[@]}" -c "create extension pgtap with schema extensions"
fi
"${P[@]}" -c "alter database $DB set search_path = public, extensions"

for f in supabase/migrations/*.sql; do
  # Supabase-only extensions are replaced by the stubs above.
  sed -E '/create extension if not exists (pgmq|pg_cron|pg_net)/d' "$f" | "${P[@]}" -f - >/dev/null
done
echo "migrations: $(ls supabase/migrations/*.sql | wc -l) applied"

status=0
for t in $(find supabase/tests -name '*.test.sql' | sort); do
  out=$(sed '/create extension if not exists pgtap/d' "$t" | psql -X -q -t -A -d "$DB" -f - 2>&1) || status=1
  if grep -qE '^not ok|ERROR|Looks like' <<<"$out"; then status=1; echo "FAIL $t"; echo "$out" | grep -vE '^ok ' ; else
    echo "PASS $t ($(grep -c '^ok ' <<<"$out") tests)"; fi
done
exit $status
