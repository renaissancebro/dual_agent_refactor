# dual_agent_refactor
🧠 Dual-Agent Coding Workflow (Gemini CLI + Claude Code + Custom Agents)

This setup allows you to combine:
	•	Gemini CLI (code analyzer)
	•	Claude Code (code editor/fixer)
	•	Your own GPT-powered AutoGen agent (planner/refactor engine)

…to refactor, organize, and improve a codebase autonomously with preview mode and human oversight.

⸻

🗂 Folder Structure

refactor_system/
├── postbox/
│   ├── todo.md               # Gemini appends todos here
│   └── completed-todos.md   # Claude moves resolved items here
├── scripts/
│   ├── run_gemini.sh        # Starts Gemini CLI in watcher mode
│   └── run_claude.sh        # Starts Claude Code in fixer mode
├── refactor_agent/          # Your custom agent logic
│   └── ...
├── refactor_target/         # Target FastAPI or project directory
└── README.md


⸻

✅ Step-by-Step Workflow

1. 🔍 Gemini CLI — Continuous Analyzer

Use this to:
	•	Detect code smells, style issues, bad loops, etc.
	•	Append each finding as an item in postbox/todo.md under “Open”

cd refactor_system
sh scripts/run_gemini.sh

You can also manually prompt Gemini:

gemini "Scan all files in refactor_target and append any needed improvements to postbox/todo.md"

2. 🛠 Claude Code — Problem Solver

Claude watches for open TODOs, then:
	•	Fixes the issue in files
	•	Records explanation in completed-todos.md
	•	Moves the TODO from todo.md

sh scripts/run_claude.sh

It acts like a committed AI dev.

3. 👨‍💻 You — Preview + Confirm

Run a preview diff using:

diff -u refactor_target/main.py refactor_target/main.py.bak

Or for multiple files:

find refactor_target -name "*.py" -exec diff -u {} {}.bak \;

If satisfied, confirm changes (optional git commit, etc).

4. 🤖 Add Custom Agent (e.g. GPT Refactor Agent)

You can:
	•	Pass todo.md into it for planning
	•	Let it suggest module splits, utils folder creation
	•	Optionally make it output FastAPI-compatible endpoint ideas

You can invoke it via CLI script or notebook:

python refactor_agent/main_agent.py


⸻

💡 Example Use Case: FastAPI Refactor

Say you want to extract a refactor() function and wrap it as an API:
	1.	Add FastAPI app in refactor_target/api.py
	2.	Add def refactor_code(code: str) -> dict: to utils
	3.	Add a TODO to postbox: “Make /refactor POST endpoint to wrap refactor_code()”
	4.	Claude will implement
	5.	Review via diff, then test

⸻

✨ CLI Alias (optional)

Add to .zshrc:

alias runflow="cd ~/refactor_system && tmux new-session \; \
  split-window -h 'sh scripts/run_gemini.sh' \; \
  split-window -v 'sh scripts/run_claude.sh' \; \
  select-pane -t 0 && clear"

Then run:

runflow


⸻

🔐 Safety: Preview Mode Always

Every edit is saved as file.py.bak before replacement. You can always run:

diff -u file.py file.py.bak

Or use git to version.

⸻

🔁 Next Additions
	•	Integrate GPT Planner (third agent)
	•	Add test bot
	•	Use watch to auto-preview changes
	•	Expose endpoints via FastAPI and monetize with Stripe

⸻

Need help writing or adjusting any of these? Ping your agent. 🚀
