# .bashrc

# Source global definitions
if [ -f /etc/bashrc ]; then
	. /etc/bashrc
fi

# User specific environment
if ! [[ "$PATH" =~ "$HOME/.local/bin:$HOME/bin:" ]]
then
    PATH="$HOME/.local/bin:$HOME/bin:$PATH"
fi
export PATH

# Uncomment the following line if you don't like systemctl's auto-paging feature:
# export SYSTEMD_PAGER=

# User specific aliases and functions
 
alias rm='rm -i'
alias cp='cp -i'
alias mv='mv -i'
export PATH=$HOME/.ollama/bin:$PATH
export OLLAMA_NUM_THREADS=$(nproc)
export OMP_NUM_THREADS=$(nproc)
export KMP_AFFINITY=granularity=fine,compact,1,0
export KMP_BLOCKTIME=0
export PATH=$HOME/.ollama/bin:$PATH
export PATH=$HOME/.ollama/bin:$PATH
export PATH="${KREW_ROOT:-$HOME/.krew}/bin:$PATH"

# ============================================
# CREDENTIALS - Load from .env file
# ============================================
# SECURITY: Never hardcode credentials here!
# Create a .env file with your secrets:
#   cp .env.example .env
#   nano .env
# The .env file is automatically ignored by git
if [ -f "$HOME/.env" ]; then
    source "$HOME/.env"
fi

export CLAUDE_DEV_ROOT="${CLAUDE_DEV_ROOT:-/root/claude-development}"

# Universal Automation System - Claude Code Integration
export UNIVERSAL_AUTOMATION_PATH="/root/Desktop/Projects/Backup-manager"
export PATH="$PATH:/root/Desktop/Projects/Backup-manager"

# Project management aliases
alias ps="/root/Desktop/Projects/Backup-manager/project_switcher.sh switch"
alias psl="/root/Desktop/Projects/Backup-manager/project_switcher.sh list"
alias psi="/root/Desktop/Projects/Backup-manager/project_switcher.sh interactive"
alias install-automation="/root/Desktop/Projects/Backup-manager/install-automation-anywhere.sh"
alias bulk-automate="/root/Desktop/Projects/Backup-manager/bulk-automate-all-projects.sh"
alias lapd-report="/root/Desktop/Projects/LAPD/core/lapd_motd.sh"

# Auto-load function for new projects
automate_if_project() {
    if [[ -f "requirements.txt" ]] || [[ -f "package.json" ]] || [[ -f "Cargo.toml" ]] || [[ -f "go.mod" ]] || [[ -f "pom.xml" ]]; then
        if [[ ! -d ".automation" ]]; then
            echo "🔧 Auto-installing automation..."
            "/root/Desktop/Projects/Backup-manager/install-automation-anywhere.sh" "$(pwd)"
        fi
    fi
}

# Hook into directory changes
cd() {
    builtin cd "$@"
    automate_if_project
}

# ========================================
# Claude Code + tmux Integration
# ========================================

# Aliases for Claude Code with tmux
alias c='claude-tmux'
alias ct='claude-tmux'
alias claude-new='claude-tmux'

# Standard Claude without tmux (for quick tasks)
alias claude-direct='claude'

# Session management
alias cls='tmux ls'                    # List Claude sessions
alias ca='tmux attach -t'              # Attach to session
alias ck='tmux kill-session -t'        # Kill session
alias cka='tmux kill-server'           # Kill all sessions

# Function to switch between tmux sessions (cs = change session)
cs() {
    if [[ -z "$1" ]]; then
        echo "Usage: cs <session-name>"
        echo ""
        echo "Available sessions:"
        tmux ls 2>/dev/null || echo "  No active sessions"
        return 1
    fi

    local target_session="$1"

    # Check if target session exists
    if ! tmux has-session -t "$target_session" 2>/dev/null; then
        echo "Error: Session '$target_session' not found"
        echo ""
        echo "Available sessions:"
        tmux ls 2>/dev/null
        return 1
    fi

    # Check if we're in a tmux session
    if [[ -n "$TMUX" ]]; then
        # We're in tmux, switch directly
        tmux switch-client -t "$target_session"
    else
        # Not in tmux, attach to target
        tmux attach -t "$target_session"
    fi
}

# Quick launch aliases for common patterns
alias claude1='claude-tmux claude1'
alias claude2='claude-tmux claude2'
alias claude3='claude-tmux claude3'
alias claude4='claude-tmux claude4'

# Monitor and Claude together
alias cmon='tmux new -s monitor /root/monitor_system.sh 10'

# Function to launch Claude in current project with auto-naming
claude() {
    # If already inside tmux, just run claude directly
    if [[ -n "$TMUX" ]]; then
        command claude "$@"
        return
    fi

    # Check if we should use tmux (can be disabled with CLAUDE_NO_TMUX=1)
    if [[ "$CLAUDE_NO_TMUX" == "1" ]]; then
        command claude "$@"
        return
    fi

    # Use tmux wrapper for persistent sessions
    claude-tmux
}

# Function to show all Claude sessions with details
claude-sessions() {
    echo "╔════════════════════════════════════════╗"
    echo "║     Active Claude Code Sessions        ║"
    echo "╚════════════════════════════════════════╝"
    echo ""

    if ! tmux ls 2>/dev/null; then
        echo "No active sessions"
        return
    fi

    echo ""
    echo "Commands:"
    echo "  ca <name>  - Attach to session"
    echo "  ck <name>  - Kill session"
    echo "  cls        - List sessions"
}

# Function to clean up orphaned Claude sessions
claude-cleanup() {
    echo "Cleaning up Claude Code sessions..."

    # Show sessions
    tmux ls 2>/dev/null

    echo ""
    read -p "Kill all sessions? (y/N): " -n 1 -r
    echo

    if [[ $REPLY =~ ^[Yy]$ ]]; then
        tmux kill-server 2>/dev/null
        echo "✅ All sessions cleaned up"
    else
        echo "Cancelled"
    fi
}

# Auto-create tmux session when SSH connects (optional)
# Uncomment to enable auto-tmux on SSH login:
# if [[ -n "$SSH_CONNECTION" ]] && [[ -z "$TMUX" ]] && [[ "$TERM" != "screen" ]]; then
#     echo "🔗 SSH detected - Starting persistent tmux session"
#     tmux new-session -A -s ssh-main
# fi

# Add tmux to PATH for global access
export PATH="/usr/local/bin:$PATH"

# ========================================
# Project Template Integration
# ========================================

# Function to initialize Claude+tmux for a project
init-claude-project() {
    local project_dir="${1:-.}"

    echo "🚀 Initializing Claude Code + tmux for project..."

    # Create CLAUDE.md if it doesn't exist
    if [[ ! -f "$project_dir/CLAUDE.md" ]]; then
        cat > "$project_dir/CLAUDE.md" << 'EOFMD'
# Project Development with Claude Code

## Session Management
This project uses tmux for persistent Claude Code sessions.

### Quick Start
```bash
# Start Claude in tmux (auto-named after project)
claude

# Or with custom name
claude-tmux my-session-name

# List active sessions
cls

# Attach to existing session
ca session-name

# Detach from session: Ctrl+B, then D
```

### Session Commands
- `c` or `ct` - Start Claude with tmux
- `cls` - List all sessions
- `ca <name>` - Attach to session
- `ck <name>` - Kill session
- `claude-sessions` - Show detailed session info

### Benefits
✅ Sessions survive SSH disconnections
✅ Resume work from anywhere
✅ Multiple projects in parallel
✅ Work survives system issues

---
Last updated: $(date)
EOFMD
        echo "✅ Created CLAUDE.md"
    fi

    # Create .tmux-project (optional project-specific tmux config)
    if [[ ! -f "$project_dir/.tmux-project" ]]; then
        cat > "$project_dir/.tmux-project" << 'EOFTMUX'
# Project-specific tmux configuration
# This file is sourced when starting tmux in this project

# Set project name
PROJECT_NAME="$(basename "$(pwd)")"

# Custom key bindings for this project
# bind-key C-t send-keys "npm test" C-m

# Pane layouts
# bind-key C-d split-window -h \; split-window -v
EOFTMUX
        echo "✅ Created .tmux-project"
    fi

    echo ""
    echo "✅ Project initialized!"
    echo "Run 'claude' to start a persistent session"
}

# Bulk initialize all projects
init-all-claude-projects() {
    local base_dir="${1:-/root/Desktop/Projects}"

    echo "🔄 Initializing Claude+tmux for all projects in: $base_dir"

    for project in "$base_dir"/*; do
        if [[ -d "$project" ]]; then
            echo ""
            echo "📂 Processing: $(basename "$project")"
            (cd "$project" && init-claude-project .)
        fi
    done

    echo ""
    echo "✅ All projects initialized!"
}

# Alias for initialization
alias init-claude='init-claude-project'
alias init-all='init-all-claude-projects'
alias proj='source /usr/local/bin/proj'

# ========================================
# Claude Code Session Management (Auto)
# ========================================

# Track last directory to avoid redundant saves
CLAUDE_LAST_DIR=""

# Function to auto-initialize and save sessions
claude_auto_session() {
    local current_dir="$(pwd)"
    
    # Only process if directory changed
    if [ "$current_dir" != "$CLAUDE_LAST_DIR" ]; then
        CLAUDE_LAST_DIR="$current_dir"
        
        # Auto-initialize if this looks like a project
        if [ -d ".git" ] || [ -f "package.json" ] || [ -f "requirements.txt" ] || [ -f "Cargo.toml" ] || [ -f "go.mod" ]; then
            # Initialize project silently
            claude-project-init > /dev/null 2>&1
        fi
    fi
}

# Hook into cd command
cd() {
    builtin cd "$@" && claude_auto_session
}

# Hook into pushd/popd
pushd() {
    builtin pushd "$@" && claude_auto_session
}

popd() {
    builtin popd "$@" && claude_auto_session
}

# Save session on shell exit
claude_exit_hook() {
    if [ -d ".git" ] || [ -f "package.json" ] || [ -f "requirements.txt" ] || [ -f "Cargo.toml" ] || [ -f "go.mod" ]; then
        claude-session-save > /dev/null 2>&1
    fi
}
trap claude_exit_hook EXIT

# Ensure ~/.local/bin is in PATH
if [[ ":$PATH:" != *":$HOME/.local/bin:"* ]]; then
    export PATH="$HOME/.local/bin:$PATH"
fi

# ============================================================================
# Claude Multi-Account Auto-Rotation System
# ============================================================================

# Enable/disable auto-rotation (set to 1 to enable, 0 to disable)
export CLAUDE_AUTO_ROTATE=${CLAUDE_AUTO_ROTATE:-1}

# Account management aliases
alias claude-accounts='claude-auto-rotate list'
alias claude-current='claude-auto-rotate current'
alias claude-usage='claude-auto-rotate usage'
alias claude-add-account='claude-account-add'
alias claude-balance='claude-auto-rotate balance'
alias claude-rotate='claude-auto-rotate rotate'

# Helper function to show account status in prompt (optional)
claude_account_prompt() {
    if [[ -f "/root/.claude/accounts/active.txt" ]]; then
        local account=$(cat /root/.claude/accounts/active.txt 2>/dev/null)
        if [[ -n "$account" ]]; then
            echo " [claude:$account]"
        fi
    fi
}

# Wrapper to enable/disable auto-rotation
claude_toggle_rotation() {
    if [[ "$CLAUDE_AUTO_ROTATE" == "1" ]]; then
        export CLAUDE_AUTO_ROTATE=0
        echo "Auto-rotation DISABLED - using single account only"
    else
        export CLAUDE_AUTO_ROTATE=1
        echo "Auto-rotation ENABLED - will auto-switch on rate limits"
    fi
}
alias claude-toggle='claude_toggle_rotation'

# ============================================================================

# Initialize for current directory on shell start
claude_auto_session > /dev/null 2>&1


# Display Keeper Security MOTD on login (only for interactive shells)
if [ -n "$PS1" ] && [ -f /root/.keeper_motd.sh ]; then
    /root/.keeper_motd.sh
fi
