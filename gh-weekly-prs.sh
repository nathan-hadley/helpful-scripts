#!/usr/bin/env bash
###############################################################################
#  gh-weekly-prs
#  Lists all pull-requests authored by you that were UPDATED during LAST
#  work-week (Mon-Fri) and writes/updates a markdown file in iCloud Drive:
#  Documents/Markdown/Limble/Weekly/<year>/<month>/<yy>-W<week>.md
###############################################################################

set -euo pipefail

# ---- 1. Calculate last work-week's Monday & Friday (ISO weeks) -------------
WD=$(date +%u) # 1=Mon … 7=Sun
if [ "$WD" -ge 6 ]; then
  # Weekend → use this week's Monday-Friday.
  START=$(date -vmon +%Y-%m-%d)
  END=$(date -vfri +%Y-%m-%d)
else
  # Weekday → previous week's Monday-Friday.
  START=$(date -v -1w -vmon +%Y-%m-%d)
  END=$(date -v -1w -vfri +%Y-%m-%d)
fi

YEAR=$(date -j -f "%Y-%m-%d" "$START" +%Y)
YY=$(date -j -f "%Y-%m-%d" "$START" +%y)
MONTH=$(date -j -f "%Y-%m-%d" "$START" +%-m)
WEEK=$(date -j -f "%Y-%m-%d" "$START" +%V)  # ISO week number

echo "[INFO] Date range: $START → $END (ISO week $WEEK)"

# ---- 2. Run search via GitHub CLI -----------------------------------------
GH_QUERY="author:@me updated:${START}..${END} is:pr"

echo "[INFO] Running GitHub search: $GH_QUERY"

ISSUES=$(
  gh pr list --state all \
             --search "$GH_QUERY" \
             --json number,title,url,state \
             --jq '.[] | select(.state != "CLOSED") | "\(.number)\t\(.title)\t\(.url)"'
)

COUNT=$(echo "$ISSUES" | grep -c '^' || true)
# Handle empty string case for grep on some shells
if [ -z "$ISSUES" ]; then COUNT=0; fi

echo "[INFO] Retrieved $COUNT pull-request(s)"

# ---- 3. Build Markdown ------------------------------------------------------
ICLOUD_DIR=~/Library/Mobile\ Documents/com~apple~CloudDocs/Documents/Markdown/Limble/Weekly
TARGET="${ICLOUD_DIR}/${YEAR}/${MONTH}/${YY}-W${WEEK}.md"

echo "[INFO] Writing markdown to $TARGET"

mkdir -p "$(dirname "$TARGET")"

{
  echo "# Week $WEEK ($START → $END)"
  echo
  echo "## Pull-requests updated during the week"
  echo
  if [[ -z "$ISSUES" ]]; then
    echo "_No pull-requests updated during this period._"
  else
    while IFS=$'\t' read -r NUM TITLE URL; do
      echo "- [#$NUM]($URL) — $TITLE"
    done <<<"$ISSUES"
  fi
  echo
} >"$TARGET"

echo "Markdown written to: $TARGET" 