#!/bin/bash
# fixer.sh
# Reads todos from ./postbox/todo.md and applies fixes

TODO_FILE="./postbox/todo.md"
DONE_FILE="./postbox/completed-todos.md"

set -x  # Enable debug output

echo "🛠️ Starting Claude Code fixer..."

while true; do
    # Extract all TODOs (lines starting with - [ ]) regardless of nesting or headings
    TODO_ITEMS=( $(grep "^- \[ \]" "$TODO_FILE" | sed 's/^ *- \[ \] *//') )

    if [[ ${#TODO_ITEMS[@]} -eq 0 ]]; then
        echo "No TODO items found in $TODO_FILE"
        break
    fi

    for ISSUE in "${TODO_ITEMS[@]}"; do
        if [[ -n "$ISSUE" ]]; then
            echo "🔧 Working on: $ISSUE"
            cd codebase
            FIX=$(claude -p "Fix the following issue in this codebase:\n\n$ISSUE")
            cd ..

            # Apply fix logic here or simulate
            echo "### Fixed: $ISSUE" >> "$DONE_FILE"
            echo "" >> "$DONE_FILE"
            echo "$FIX" >> "$DONE_FILE"
            echo "" >> "$DONE_FILE"

            # Remove the processed item from todo.md (all occurrences)
            sed -i '' "/- \[ \] *$(echo "$ISSUE" | sed 's/[\&/]/\\&/g')/d" "$TODO_FILE"
            echo "✅ Moved item to $DONE_FILE"
        fi
    done
    sleep 10  # shorter interval for testing
done
