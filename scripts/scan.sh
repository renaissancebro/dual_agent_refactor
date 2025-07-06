#!/bin/bash
# scan.sh - Manual code scanner using Gemini CLI

TODO_FILE="./postbox/todo.md"

# Check if files were specified as arguments
if [[ $# -eq 0 ]]; then
    echo "🔍 Scanning current directory with Gemini..."
    echo "💡 Tip: You can specify files like: ./scripts/scan.sh file1.py file2.py"
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
