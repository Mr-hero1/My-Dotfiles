#!/usr/bin/env bash
set -euo pipefail

PLAYER_ARG=""
if [ $# -ge 1 ] && [ -n "$1" ]; then
  PLAYER_ARG="--player=$1"
fi

out=$(playerctl $PLAYER_ARG metadata --format '{{position}} {{mpris:length}}' 2>/dev/null) || { printf '0\n'; exit 0; }
read -r pos len <<< "$out"

# If either field is missing, return 0
if [ -z "$pos" ] || [ -z "$len" ]; then
  printf '0\n'
  exit 0
fi

pct=$(awk -v p="$pos" -v l="$len" 'BEGIN{
  gsub(/[^0-9.]/,"",p); gsub(/[^0-9.]/,"",l);   # strip non-numeric
  if (l=="" || l==0) { print 0; exit }
  if (l > 1e6 && p < 1e5) l = l / 1e6;          # heuristics for microseconds -> seconds
  if (p > 1e6 && l < 1e5) p = p / 1e6;
  pct = (p / l) * 100;
  if (pct < 0) pct = 0;
  if (pct > 100) pct = 100;
  printf "%d\n", (pct + 0.5);
}')
printf '%s\n' "$pct"
