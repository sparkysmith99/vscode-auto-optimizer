# Workspace Auto-Optimization System
## Automatically configure VS Code for different project types

## 📋 **How It Works**
The system automatically detects your project type and applies optimal settings:
- Python/Tkinter → Industrial HMI tools, auto-approve Python commands
- Web Development → Prettier, ESLint, live server tools
- Android/Java → Gradle, ADB, Java tools
- Data Science → Jupyter, pandas, matplotlib tools

---

## 🚀 **Quick Start**

### **Option 1: Auto-Detect (Recommended)**
```powershell
# Navigate to your project
cd "C:\Your\Project\Path"

# Run optimizer (auto-detects type)
powershell -ExecutionPolicy Bypass -File "$env:USERPROFILE\.vscode\optimize-workspace.ps1"
```

### **Option 2: Specify Type**
```powershell
# Choose specific template
powershell -ExecutionPolicy Bypass -File "$env:USERPROFILE\.vscode\optimize-workspace.ps1" -TemplateType "python-tkinter"
```

Available types:
- `python-tkinter` - GUI apps, dashboards, HMI systems
- `web-dev` - HTML/CSS/JS, Cordova, web apps
- `android-java` - Android Studio, Gradle projects
- `data-science` - Jupyter, pandas, analysis

---

## 🎯 **What Gets Optimized**

### **For BMR Dashboard (Python Tkinter):**
✅ Auto-approve: `python bmr_dashboard_restored.py`, `pip install pillow`
✅ Type checking: Basic mode (not too strict)
✅ File exclusions: `__pycache__`, `.pyc` files
✅ Extensions: Python, Pylance, AutoDocstring

### **For Android Projects:**
✅ Auto-approve: `gradlew build`, `adb install`, Java commands
✅ File exclusions: `.gradle`, `build` folders
✅ Extensions: Java Pack, Gradle support

### **For Web Projects:**
✅ Auto-approve: `npm install`, `npm start`, live-server
✅ Format on save with Prettier
✅ Extensions: ESLint, Prettier, LiveServer

---

## 🔧 **Manual Customization**

Edit workspace settings anytime:
```
Your Project/.vscode/settings.json
```

Add project-specific commands:
```json
"chat.tools.terminal.autoApprove": {
    "python my_specific_script.py": true
}
```

---

## 📦 **Add Your Own Templates**

Create new template in: `C:\Users\Admin\.vscode\workspace-templates\`

Example - `my-custom.json`:
```json
{
    "name": "My Custom Project Type",
    "description": "Description here",
    "settings": {
        "chat.tools.terminal.autoApprove": {
            "mycommand": true
        }
    },
    "extensions": ["extension.id"]
}
```

Use it:
```powershell
optimize-workspace.ps1 -TemplateType "my-custom"
```

---

## 🔄 **Global vs Workspace Settings**

**Global** (`%APPDATA%\Code\User\settings.json`):
- Applies to ALL projects
- Use for universal commands: `python`, `git`, `pip`
- Current: 40 commands (under 128 limit)

**Workspace** (`Project/.vscode/settings.json`):
- Applies ONLY to current project
- Use for project-specific commands
- No limit - can have 1000+ if needed

**Combined**: VS Code merges both (workspace overrides global)

---

## 💡 **Tips**

1. **Run optimizer when starting new project**
2. **Re-run if project type changes** (e.g., adding Jupyter notebooks)
3. **Workspace settings travel with project** (commit `.vscode/settings.json`)
4. **Global settings stay on your machine**

---

## 🆘 **Troubleshooting**

**Script won't run?**
```powershell
Set-ExecutionPolicy -Scope CurrentUser -ExecutionPolicy RemoteSigned
```

**Wrong type detected?**
```powershell
optimize-workspace.ps1 -TemplateType "correct-type"
```

**Want to see current settings?**
Open: `.vscode/settings.json` in your project

---

## ⚡ **Pro Tip: Add to VS Code Tasks**

Add to `.vscode/tasks.json`:
```json
{
    "label": "Optimize Workspace",
    "type": "shell",
    "command": "powershell",
    "args": ["-ExecutionPolicy", "Bypass", "-File", 
             "$env:USERPROFILE\\.vscode\\optimize-workspace.ps1"],
    "problemMatcher": []
}
```

Run with: `Ctrl+Shift+P` → `Tasks: Run Task` → `Optimize Workspace`
