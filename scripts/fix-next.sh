#!/bin/bash
# fix-next.sh - Manual fixer that processes one TODO at a time

TODO_FILE="./postbox/todo.md"
DONE_FILE="./postbox/completed-todos.md"

echo "🛠️ Manual TODO fixer - one item at a time"

# Get the first TODO item
FIRST_TODO=$(grep "^- \[ \]" "$TODO_FILE" | head -1 | sed 's/^ *- \[ \] *//')

if [[ -z "$FIRST_TODO" ]]; then
    echo "❌ No TODO items found in $TODO_FILE"
    exit 1
fi

echo ""
echo "📝 Next TODO to fix:"
echo "   $FIRST_TODO"
echo ""

# Ask for confirmation
read -p "🤔 Do you want Claude to fix this issue? (y/n): " -n 1 -r
echo

if [[ $REPLY =~ ^[Yy]$ ]]; then
    echo "🔧 Calling Claude to fix: $FIRST_TODO"

    # Get the fix from Claude (without file permissions for now)
    FIX=$(claude -p "Fix the following issue in this codebase:\n\n$FIRST_TODO")

    echo ""
    echo "💡 Claude's suggested fix:"
    echo "----------------------------------------"
    echo "$FIX"
    echo "----------------------------------------"
    echo ""

    # Ask if user wants to apply the fix
    read -p "✅ Do you want to apply this fix? (y/n): " -n 1 -r
    echo

    if [[ $REPLY =~ ^[Yy]$ ]]; then
        echo "🔧 Applying fix with file permissions..."
        claude --add-dir . -p "Apply this fix to the codebase:\n\n$FIX"

        # Record the fix
        echo "### Fixed: $FIRST_TODO" >> "$DONE_FILE"
        echo "" >> "$DONE_FILE"
        echo "$FIX" >> "$DONE_FILE"
        echo "" >> "$DONE_FILE"

        # Remove from todo.md
        sed -i '' "/- \[ \] *$(echo "$FIRST_TODO" | sed 's/[\&/]/\\&/g')/d" "$TODO_FILE"

        echo "✅ Fix applied and recorded!"
    else
        echo "❌ Fix not applied"
    fi
else
    echo "❌ Skipped this TODO"
fi

echo ""
echo "📋 Remaining TODOs:"
if grep -q "^- \[ \]" "$TODO_FILE"; then
    grep "^- \[ \]" "$TODO_FILE" | head -5
    if [[ $(grep "^- \[ \]" "$TODO_FILE" | wc -l) -gt 5 ]]; then
        echo "   ... and $(($(grep "^- \[ \]" "$TODO_FILE" | wc -l) - 5)) more"
    fi
else
    echo "   No more TODOs!"
fi
