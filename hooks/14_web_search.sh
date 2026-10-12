#!/data/data/com.termux/files/usr/bin/bash
q=$(printf '%s' "$ARG" | jq -sRr @uri)
curl -sL -m 20 "https://duckduckgo.com/html/?q=$q" \
  | grep -oE 'result__a[^>]*>[^<]+' | head -8 | sed 's/.*>//'
