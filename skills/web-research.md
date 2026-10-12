# SKILL: web-research
Purpose: Search web + summarize top results.

Tools to use:
- 14_web_search (duckduckgo HTML)
- 12_http_get (fetch page)

Steps:
1. Query = user text minus trigger word
2. Run: bash ~/.kalki/dispatch.sh 14_web_search "$Query"
3. Take top 3 URLs
4. For each: bash ~/.kalki/dispatch.sh 12_http_get "$URL"
5. Summarize via brain (Hinglish, 3 bullets)

When: research karo, dhoondho, search karo.
