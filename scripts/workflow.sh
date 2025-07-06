#!/bin/bash
# workflow.sh - Main manual workflow script

echo "🚀 Dual-Agent Manual Workflow"
echo "=============================="
echo "📍 Current directory: $(pwd)"
echo ""

while true; do
    echo "Choose an action:"
    echo "1. 🔍 Scan codebase (Gemini) - current directory"
    echo "2. 🔍 Scan specific files (Gemini) - specify files"
    echo "3. 🛠️  Fix next TODO (Claude)"
    echo "4. 📋 View current TODOs"
    echo "5. ✅ View completed fixes"
    echo "6. 🔄 Reset workflow (clear all)"
    echo "7. 🚪 Exit"
    echo ""

    read -p "Enter your choice (1-7): " -n 1 -r
    echo ""
    echo ""

    case $REPLY in
        1)
            echo "🔍 Running code scan on current directory..."
            ./scripts/scan.sh
            ;;
        2)
            echo "🔍 Running code scan on specific files..."
            read -p "Enter file names (space-separated): " FILES
            if [[ -n "$FILES" ]]; then
                ./scripts/scan.sh $FILES
            else
                echo "❌ No files specified"
            fi
            ;;
        3)
            echo "🛠️  Running fixer..."
            ./scripts/fix-next.sh
            ;;
        4)
            echo "📋 Current TODOs:"
            if [[ -f "./postbox/todo.md" ]]; then
                cat "./postbox/todo.md"
            else
                echo "   No todo.md file found"
            fi
            ;;
        5)
            echo "✅ Completed fixes:"
            if [[ -f "./postbox/completed-todos.md" ]]; then
                cat "./postbox/completed-todos.md"
            else
                echo "   No completed-todos.md file found"
            fi
            ;;
        6)
            echo "🔄 Resetting workflow..."
            read -p "Are you sure? This will clear all TODOs and completed items (y/n): " -n 1 -r
            echo ""
            if [[ $REPLY =~ ^[Yy]$ ]]; then
                > "./postbox/todo.md"
                > "./postbox/completed-todos.md"
                echo "✅ Workflow reset!"
            else
                echo "❌ Reset cancelled"
            fi
            ;;
        7)
            echo "👋 Goodbye!"
            exit 0
            ;;
        *)
            echo "❌ Invalid choice. Please enter 1-7."
            ;;
    esac

    echo ""
    echo "=============================="
    echo ""
done
