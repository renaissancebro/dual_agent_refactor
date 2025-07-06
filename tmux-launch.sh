#!/bin/bash
# tmux-launch.sh
# Launches both agents in split panes

SESSION="dual-agent"

tmux new-session -d -s $SESSION
tmux send-keys -t $SESSION "./inspector.sh" C-m
tmux split-window -h -t $SESSION
tmux send-keys -t $SESSION "./fixer.sh" C-m
tmux attach -t $SESSION
