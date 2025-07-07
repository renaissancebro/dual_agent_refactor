#!/bin/bash
# scan.sh - Manual code scanner using Gemini CLI

# Get the target directory (where we're working)
TARGET_DIR="$(pwd)"
TODO_FILE="$TARGET_DIR/postbox/todo.md"

# Create postbox directory if it doesn't exist
mkdir -p "$TARGET_DIR/postbox"

# Check if files were specified as arguments
if [[ $# -eq 0 ]]; then
    echo "🔍 Scanning current directory with Gemini..."
    echo "📁 Target: $TARGET_DIR"
    echo "💡 Tip: You can specify files like: scan.sh file1.py file2.py"
    echo ""

    # Scan current directory
    OUTPUT=$(gemini -a -p "Scan this codebase and list specific improvements in markdown TODO format only.")
else
    echo "🔍 Scanning specified files with Gemini..."
    echo "📁 Files: $@"
    echo ""

    # Scan specific files
    FILES_ARG=""
    for file in "$@"; do
        # Handle fzf output which may have newlines
        file=$(echo "$file" | tr '\n' ' ' | xargs)
        FILES_ARG="$FILES_ARG $file"
    done

    OUTPUT=$(gemini -p "Scan these specific files and list specific improvements in markdown TODO format only. Files:$FILES_ARG")
fi

echo "## Open" > "$TODO_FILE"
echo "$OUTPUT" >> "$TODO_FILE"
echo "✅ Updated $TODO_FILE"

echo ""
echo "📋 Current TODOs:"
cat "$TODO_FILE"
