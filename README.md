# dual_agent_refactor

🧠 Dual-Agent Coding Workflow (Gemini CLI + Claude Code + Manual Control)

This setup allows you to combine:
• Gemini CLI (code analyzer)
• Claude Code (code editor/fixer)
• Manual workflow control with human oversight

…to refactor, organize, and improve a codebase with full control over the process.

⸻

🗂 Folder Structure

dual_agent_refactor/
├── postbox/
│ ├── todo.md # Gemini appends todos here
│ └── completed-todos.md # Claude moves resolved items here
├── scripts/
│ ├── workflow.sh # Main interactive workflow menu
│ ├── scan.sh # Manual Gemini scanner
│ ├── fix-next.sh # Manual Claude fixer (one TODO at a time)
│ ├── inspector.sh # Legacy auto-scanner (runs every 60s)
│ └── fixer.sh # Legacy auto-fixer (runs every 60s)
├── codebase/ # Example target directory (optional)
└── README.md

⸻

✅ Step-by-Step Manual Workflow

1. 🔍 **Start the Workflow**

   ```bash
   ./scripts/workflow.sh
   ```

   This opens an interactive menu showing your current directory.

2. 🔍 **Scan Your Code**

   - **Option A**: Scan current directory

     - Choose `1` from menu
     - Gemini analyzes all files in current directory

   - **Option B**: Scan specific files
     - Choose `2` from menu
     - Enter file names: `main.py test.py utils.py`
     - Gemini analyzes only those files

3. 🛠️ **Fix Issues One by One**

   - Choose `3` from menu
   - Claude shows you the fix for the first TODO
   - You decide whether to apply it
   - Repeat until all TODOs are done

4. 📋 **Monitor Progress**
   - Choose `4` to view current TODOs
   - Choose `5` to view completed fixes
   - Choose `6` to reset workflow

⸻

🚀 **Direct Command Usage**

```bash
# Navigate to your project
cd /path/to/your/project

# Scan current directory
./scripts/scan.sh

# Scan specific files
./scripts/scan.sh main.py test.py utils.py

# Fix next TODO
./scripts/fix-next.sh

# Start interactive workflow
./scripts/workflow.sh
```

⸻

💡 **Example Use Cases**

**FastAPI Project Refactor:**

```bash
cd ~/my-fastapi-project
./scripts/workflow.sh
# Choose 2 → Enter: app.py models.py routes.py
# Choose 3 → Review and apply fixes
```

**Python Script Cleanup:**

```bash
cd ~/my-scripts
./scripts/scan.sh *.py
./scripts/fix-next.sh
```

**Multi-language Project:**

```bash
cd ~/my-project
./scripts/scan.sh src/**/*.py src/**/*.js
./scripts/fix-next.sh
```

⸻

🔐 **Safety Features**

- **Manual Approval**: You see each fix before applying
- **File Permissions**: Claude asks permission before writing files
- **Current Directory**: Works from any directory, not just hardcoded paths
- **Flexible Targeting**: Scan all files or specific files
- **Progress Tracking**: See what's done and what's left

⸻

⚙️ **Legacy Auto-Mode (Optional)**

If you want the original automatic workflow:

```bash
# Start both agents in tmux
./tmux-launch.sh

# Or run individually
./scripts/inspector.sh  # Gemini scanner (every 60s)
./scripts/fixer.sh      # Claude fixer (every 60s)
```

⸻

✨ **CLI Alias (Optional)**

Add to `~/.zshrc`:

```bash
alias dualflow="cd ~/dual_agent_refactor && ./scripts/workflow.sh"
```

Then run:

```bash
dualflow
```

⸻

🔁 **Next Additions**
• Add test generation agent
• Integrate with git for version control
• Add support for different programming languages
• Create web interface for workflow management

⸻

Need help writing or adjusting any of these? Ping your agent. 🚀
