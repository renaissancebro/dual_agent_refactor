#!/bin/bash
# inspector.sh
# Watches for code issues and logs them to ./postbox/todo.md

TODO_FILE="./postbox/todo.md"
PROJECT_PATH=$(pwd)

echo "📋 Starting Gemini CLI code inspector..."

while true; do
    echo "🔍 Scanning codebase..."
    OUTPUT=$(gemini "Scan this codebase and list specific improvements in markdown TODO format only. Path: $PROJECT_PATH")

    echo -e "\n## Open\n$OUTPUT" > "$TODO_FILE"
    echo "✅ Updated $TODO_FILE"
    sleep 60  # scan interval
done
