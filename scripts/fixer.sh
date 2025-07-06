#!/bin/bash
# fixer.sh
# Reads todos from ./postbox/todo.md and applies fixes

TODO_FILE="./postbox/todo.md"
DONE_FILE="./postbox/completed-todos.md"

echo "🛠️ Starting Claude Code fixer..."

while true; do
    if grep -q "## Open" "$TODO_FILE"; then
        ISSUE=$(awk '/## Open/{flag=1;next}/##/{flag=0}flag' "$TODO_FILE")

        if [[ -n "$ISSUE" ]]; then
            echo "🔧 Working on: $ISSUE"
            FIX=$(claude "Fix the following issue in this codebase:\n\n$ISSUE")

            # Apply fix logic here or simulate
            echo -e "### Fixed: $ISSUE\n\n$FIX\n" >> "$DONE_FILE"
            sed -i '' '/## Open/,/##/{//!d}' "$TODO_FILE"
            echo "✅ Moved item to $DONE_FILE"
        fi
    fi
    sleep 60  # fix interval
done
