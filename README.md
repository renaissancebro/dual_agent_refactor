# dual_agent_refactor

🧠 AI Code Helper - Make Your Code Better!

This tool helps you find and fix problems in your code using two AI helpers:

- **Gemini** (finds problems)
- **Claude** (fixes problems)

You stay in control - you decide what to fix and when!

⸻

## 🗂 What's Inside

```
dual_agent_refactor/
├── scripts/
│   ├── workflow.sh          # Main menu - start here!
│   ├── scan.sh              # Find problems in your code
│   └── fix-next.sh          # Fix one problem at a time
├── postbox/
│   ├── todo.md              # List of problems found
│   └── completed-todos.md   # List of problems fixed
└── README.md
```

⸻

## 🚀 How to Use (Super Simple!)

### Step 1: Start the Tool

```bash
./scripts/workflow.sh
```

This opens a menu that looks like this:

```
🚀 Dual-Agent Manual Workflow
=============================
📍 Current directory: /your/project

Choose an action:
1. 🔍 Scan codebase (Gemini) - current directory
2. 🔍 Scan specific files (Gemini) - specify files
3. 🛠️  Fix next TODO (Claude)
4. 🎯 Edit specific file (Claude) - direct file editing
5. 📋 View current TODOs
6. ✅ View completed fixes
7. 🔄 Reset workflow (clear all)
8. 🚪 Exit

Enter your choice (1-8):
```

### Step 2: Find Problems

**Option A: Check all files in current folder**

- Type `1` and press Enter
- Gemini will look at all your code files
- Problems will be saved in `postbox/todo.md`

**Option B: Check specific files**

- Type `2` and press Enter
- A file picker will open (if you have fzf installed)
- Use Tab to select files, Enter to confirm
- Or type file names like: `main.py test.py`

### Step 3: Fix Problems

- Type `3` and press Enter
- You'll see the first problem found
- Claude will suggest a fix
- You decide: `y` to apply, `n` to skip

### Step 4: Edit Files Directly (Optional)

- Type `4` and press Enter
- Pick a file to edit
- Tell Claude what you want to change
- Changes are applied immediately

⸻

## 📝 Examples

### Example 1: Fix a Python Project

```bash
# Go to your project folder
cd ~/my-python-project

# Start the tool
./scripts/workflow.sh

# Type 1 to scan all files
# Type 3 to fix problems one by one
# Type y to apply each fix
```

### Example 2: Fix Specific Files

```bash
cd ~/my-project
./scripts/workflow.sh

# Type 2 to scan specific files
# Select: main.py, utils.py, test.py
# Type 3 to fix problems
```

### Example 3: Edit One File

```bash
cd ~/my-project
./scripts/workflow.sh

# Type 4 to edit a file directly
# Select: config.py
# Type: "Add better error handling"
```

⸻

## 🎯 Quick Commands

**Start the main menu:**

```bash
./scripts/workflow.sh
```

**Scan current folder:**

```bash
./scripts/scan.sh
```

**Scan specific files:**

```bash
./scripts/scan.sh main.py test.py
```

**Fix next problem:**

```bash
./scripts/fix-next.sh
```

⸻

## 🔧 Setup (One Time)

### 1. Make scripts work

```bash
chmod +x scripts/*.sh
```

### 2. Install fzf (optional - for better file picking)

```bash
brew install fzf
```

### 3. Make sure you have Gemini and Claude CLI tools

```bash
# Check if they work
gemini --help
claude --help
```

⸻

## 🛡️ Safety Features

- **You're in control**: You see every fix before it's applied
- **No automatic changes**: Nothing happens without your permission
- **Work anywhere**: Use it in any folder with any files
- **Pick your files**: Choose exactly which files to work on

⸻

## ❓ Common Questions

**Q: What if I don't have fzf installed?**
A: The tool will ask you to type file names instead of picking them.

**Q: Can I undo changes?**
A: Yes! The tool asks permission before making any changes.

**Q: What types of files can it work with?**
A: Any text files - Python, JavaScript, HTML, etc.

**Q: Do I need to be in a specific folder?**
A: No! You can run it from any folder with any files.

⸻

## 🎉 That's It!

1. **Start**: `./scripts/workflow.sh`
2. **Scan**: Choose option 1 or 2
3. **Fix**: Choose option 3
4. **Repeat**: Keep fixing until done!

The tool does the hard work, you stay in control! 🚀
