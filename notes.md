## Notes

alias runflow="cd ~/dual_agent_refactor && tmux new-session \; \
  split-window -h 'sh scripts/inspector.sh' \; \
  split-window -v 'sh scripts/fixer.sh' \; \
  select-pane -t 0 && clear"
