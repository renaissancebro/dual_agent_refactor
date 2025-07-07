#!/bin/bash
# fix-next.sh - Manual fixer that processes one TODO at a time

# Get the target directory (where we're working)
TARGET_DIR="$(pwd)"
TODO_FILE="$TARGET_DIR/postbox/todo.md"
DONE_FILE="$TARGET_DIR/postbox/completed-todos.md"

echo "🛠️ Manual TODO fixer - one item at a time"
echo "📁 Target: $TARGET_DIR"

# Create postbox directory if it doesn't exist
mkdir -p "$TARGET_DIR/postbox"

# Check if fzf is available
if ! command -v fzf &> /dev/null; then
    FZF_AVAILABLE=false
else
    FZF_AVAILABLE=true
fi

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

# Ask if user wants to specify a file to focus on
read -p "🎯 Do you want to specify a file to focus on? (y/n): " -n 1 -r
echo

TARGET_FILE=""
if [[ $REPLY =~ ^[Yy]$ ]]; then
    if [[ "$FZF_AVAILABLE" == true ]]; then
        echo "Select file to focus on (optional - press Enter to skip):"
        TARGET_FILE=$(fzf --query "." --prompt="Focus on file > " --preview="echo {}" --preview-window=up:3)
        if [[ -n "$TARGET_FILE" ]]; then
            echo "📁 Focusing on: $TARGET_FILE"
        else
            echo "⚠️ No file selected, will work on all files"
        fi
    else
        read -p "Enter file name to focus on (or press Enter to skip): " TARGET_FILE
        if [[ -n "$TARGET_FILE" ]]; then
            echo "📁 Focusing on: $TARGET_FILE"
        else
            echo "⚠️ No file specified, will work on all files"
        fi
    fi
fi

# Ask for confirmation
read -p "🤔 Do you want Claude to fix this issue? (y/n): " -n 1 -r
echo

if [[ $REPLY =~ ^[Yy]$ ]]; then
    echo "🔧 Calling Claude to fix: $FIRST_TODO"

    # Build the prompt based on whether a target file was specified
    if [[ -n "$TARGET_FILE" ]]; then
        PROMPT="Fix the following issue in this codebase, focusing specifically on the file '$TARGET_FILE':\n\n$FIRST_TODO"
    else
        PROMPT="Fix the following issue in this codebase:\n\n$FIRST_TODO"
    fi

    # Get the fix from Claude (without file permissions for now)
    FIX=$(claude "$PROMPT")

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

        # Apply fix with target file focus if specified
        if [[ -n "$TARGET_FILE" ]]; then
            claude --add-directory "$TARGET_DIR" "Apply this fix to the codebase, focusing on '$TARGET_FILE':\n\n$FIX"
        else
            claude --add-directory "$TARGET_DIR" "Apply this fix to the codebase:\n\n$FIX"
        fi

        # Record the fix
        echo "### Fixed: $FIRST_TODO" >> "$DONE_FILE"
        if [[ -n "$TARGET_FILE" ]]; then
            echo "**Target file:** $TARGET_FILE" >> "$DONE_FILE"
        fi
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
