#!/bin/bash
# workflow.sh - Main manual workflow script

# Get the directory where this script is located
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
# Get the target directory (where we want to work on code)
TARGET_DIR="$(pwd)"

# Check if fzf is installed
if ! command -v fzf &> /dev/null; then
    echo "⚠️  fzf is not installed. Install it with: brew install fzf"
    echo "   Falling back to manual file input..."
    FZF_AVAILABLE=false
else
    FZF_AVAILABLE=true
fi

echo "🚀 Dual-Agent Manual Workflow"
echo "=============================="
echo "📍 Target directory: $TARGET_DIR"
echo "🔧 Scripts from: $SCRIPT_DIR"
echo ""

while true; do
        echo "Choose an action:"
    echo "1. 🔍 Scan codebase (Gemini) - current directory"
    echo "2. 🔍 Scan specific files (Gemini) - specify files"
    echo "3. 🛠️  Fix next TODO (Claude)"
    echo "4. 🎯 Edit specific file (Claude) - direct file editing"
    echo "5. 📋 View current TODOs"
    echo "6. ✅ View completed fixes"
    echo "7. 🔄 Reset workflow (clear all)"
    echo "8. 🚪 Exit"
    echo ""

    read -p "Enter your choice (1-8): " -n 1 -r
    echo ""
    echo ""

    case $REPLY in
        1)
            echo "🔍 Running code scan on current directory..."
            cd "$TARGET_DIR" && "$SCRIPT_DIR/scan.sh"
            ;;
        2)
            echo "🔍 Running code scan on specific files..."
            if [[ "$FZF_AVAILABLE" == true ]]; then
                echo "Select files to scan (use Tab to select multiple, Enter to confirm):"
                cd "$TARGET_DIR"
                FILES=$(fzf --multi --query "." --prompt="Scan files > " --preview="echo {}" --preview-window=up:3)
                if [[ -n "$FILES" ]]; then
                    echo "📁 Selected files: $FILES"
                    "$SCRIPT_DIR/scan.sh" $FILES
                else
                    echo "⚠️ No files selected."
                fi
            else
                read -p "Enter file names (space-separated): " FILES
                if [[ -n "$FILES" ]]; then
                    cd "$TARGET_DIR" && "$SCRIPT_DIR/scan.sh" $FILES
                else
                    echo "❌ No files specified"
                fi
            fi
            ;;
        3)
            echo "🛠️  Running fixer..."
            cd "$TARGET_DIR" && "$SCRIPT_DIR/fix-next.sh"
            ;;
        4)
            echo "🎯 Direct file editing..."
            if [[ "$FZF_AVAILABLE" == true ]]; then
                echo "Select file to edit:"
                cd "$TARGET_DIR"
                TARGET_FILE=$(fzf --query "." --prompt="Edit file > " --preview="echo {}" --preview-window=up:3)
                if [[ -n "$TARGET_FILE" ]]; then
                    echo "📁 Editing: $TARGET_FILE"
                    read -p "Describe what you want to change: " EDIT_REQUEST
                    if [[ -n "$EDIT_REQUEST" ]]; then
                        claude --add-directory "$TARGET_DIR" "Edit the file '$TARGET_FILE' with the following request:\n\n$EDIT_REQUEST"
                        echo "✅ Edit applied!"
                    else
                        echo "❌ No edit request provided"
                    fi
                else
                    echo "⚠️ No file selected."
                fi
            else
                read -p "Enter file name to edit: " TARGET_FILE
                if [[ -n "$TARGET_FILE" ]]; then
                    read -p "Describe what you want to change: " EDIT_REQUEST
                    if [[ -n "$EDIT_REQUEST" ]]; then
                        claude --add-directory "$TARGET_DIR" "Edit the file '$TARGET_FILE' with the following request:\n\n$EDIT_REQUEST"
                        echo "✅ Edit applied!"
                    else
                        echo "❌ No edit request provided"
                    fi
                else
                    echo "❌ No file specified"
                fi
            fi
            ;;
        5)
            echo "📋 Current TODOs:"
            if [[ -f "$TARGET_DIR/postbox/todo.md" ]]; then
                cat "$TARGET_DIR/postbox/todo.md"
            else
                echo "   No todo.md file found"
            fi
            ;;
        6)
            echo "✅ Completed fixes:"
            if [[ -f "$TARGET_DIR/postbox/completed-todos.md" ]]; then
                cat "$TARGET_DIR/postbox/completed-todos.md"
            else
                echo "   No completed-todos.md file found"
            fi
            ;;
        7)
            echo "🔄 Resetting workflow..."
            read -p "Are you sure? This will clear all TODOs and completed items (y/n): " -n 1 -r
            echo ""
            if [[ $REPLY =~ ^[Yy]$ ]]; then
                mkdir -p "$TARGET_DIR/postbox"
                > "$TARGET_DIR/postbox/todo.md"
                > "$TARGET_DIR/postbox/completed-todos.md"
                echo "✅ Workflow reset!"
            else
                echo "❌ Reset cancelled"
            fi
            ;;
        8)
            echo "👋 Goodbye!"
            exit 0
            ;;
        *)
            echo "❌ Invalid choice. Please enter 1-8."
            ;;
    esac

    echo ""
    echo "=============================="
    echo ""
done
