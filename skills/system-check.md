# SKILL: system-check
Purpose: Full device health report.

Steps:
1. 06_battery → battery %
2. shell "free -h | head -2" → RAM
3. shell "df -h /data | tail -1" → storage
4. shell "uname -a" → kernel
5. 07_location → GPS (optional)
6. Summarize as 4-line Hinglish report.

When: system check, health, kya haal hai phone ka.
