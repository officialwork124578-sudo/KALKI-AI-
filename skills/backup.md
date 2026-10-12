# SKILL: backup
Purpose: Create timestamped backup of a path.

Steps:
1. TARGET="${1:-$HOME}"
2. STAMP=$(date +%Y%m%d_%H%M%S)
3. DEST="$HOME/.kalki/backups/$(basename $TARGET)_$STAMP"
4. mkdir -p "$DEST"
5. tar -czf "$DEST.tar.gz" -C "$(dirname $TARGET)" "$(basename $TARGET)"
6. echo "backup → $DEST.tar.gz"

When: user says backup, safe copy, snapshot.
