#!/bin/bash
# tmux-launch.sh
# Launches nvim and dual-agent workflow in split panes

SESSION="code-workflow"
WORKFLOW_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

# Get target directory (default to current directory)
TARGET_DIR="${1:-$(pwd)}"

echo "🚀 Starting tmux session with:"
echo "   📁 Target directory: $TARGET_DIR"
echo "   🔧 Workflow from: $WORKFLOW_DIR"

# Create new session
tmux new-session -d -s $SESSION -c "$TARGET_DIR"

# Left pane: nvim
tmux send-keys -t $SESSION "nvim ." C-m

# Right pane: workflow
tmux split-window -h -t $SESSION -c "$TARGET_DIR"
tmux send-keys -t $SESSION "$WORKFLOW_DIR/scripts/workflow.sh" C-m

# Attach to session
tmux attach -t $SESSION
