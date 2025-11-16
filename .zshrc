export ZSH="$HOME/.oh-my-zsh"
ZSH_THEME="robbyrussell"
plugins=(git colored-man-pages z sudo)
# Avoid OMZ instant prompt parsing under bash
export POWERLEVEL9K_DISABLE_CONFIGURATION_WIZARD=true

# Load OMZ
[[ -r "$ZSH/oh-my-zsh.sh" ]] && source "$ZSH/oh-my-zsh.sh"

# Path (our tools first)
export PATH="$HOME/.local/bin:/usr/local/bin:$PATH"

# FZF (Ctrl+R)
[[ -r /usr/share/fzf/shell/key-bindings.zsh ]] && source /usr/share/fzf/shell/key-bindings.zsh
bindkey '^R' fzf-history-widget

# Autojump
[[ -r /usr/share/autojump/autojump.zsh ]] && source /usr/share/autojump/autojump.zsh

# Smart ls aliases
if command -v eza >/dev/null 2>&1; then
  alias ll="eza -l --icons"
  alias la="eza -la --icons"
elif command -v lsd >/dev/null 2>&1; then
  alias ll="lsd -l"
  alias la="lsd -la"
else
  alias ll="ls -l --group-directories-first --color=auto"
  alias la="ls -la --group-directories-first --color=auto"
fi

# Quality-of-life & educational helpers
alias cat="bat --paging=never"
alias sys="btop"
alias how='curl -s cheat.sh'
explain(){ local q; q="$(printf '%s' "$*" | jq -sRr @uri)"; curl -s "https://explainshell.com/explain?cmd=$q" | lynx -stdin -dump; }
alias why=explain
learn(){ echo "=== MAN PAGE ==="; man "$1" | head -n 20; echo; echo "=== TLDR EXAMPLES ==="; tldr "$1"; }

# Starship prompt
eval "$(starship init zsh)"

# History quality
setopt hist_ignore_dups hist_reduce_blanks share_history
HISTFILE=~/.zsh_history; HISTSIZE=200000; SAVEHIST=200000

# Auto-load active API key if set via ccx-auth
if command -v ccx-auth >/dev/null 2>&1; then
  [[ -f "$HOME/.config/ccx/active" ]] && eval "$(ccx-auth env 2>/dev/null || true)"
fi
export PATH="$HOME/.local/bin:$PATH"
export PATH="$HOME/.local/bin:$PATH"
# alias claude="anthropic" # Commented out - conflicts with Claude Code CLI
export PATH="$HOME/.npm-global/bin:$PATH"

# ---------- Projects ----------
PROJECT_ROOT="${PROJECT_ROOT:-$HOME/Desktop/Projects}"
p() {
  local sel
  sel="$(find "$PROJECT_ROOT" -maxdepth 1 -mindepth 1 -type d -printf "%f\n" 2>/dev/null | sort | fzf --prompt="project> ")" || return
  [[ -n "$sel" ]] || return
  cd "$PROJECT_ROOT/$sel" || return
  [[ -f ./.zshrc.local ]] && source ./.zshrc.local
}
work() { local name="${1:-$(basename "$PWD")}"; tmux new -As "$name"; }

# proj wrapper (persist cd; no exec)
PROJ_BIN="/usr/local/bin/proj"
proj() {
  local cmd="${1:-list}"
  case "$cmd" in
    list|'') "$PROJ_BIN" list ;;
    open)
      local target="${2:-}"; [[ -n "$target" ]] || { echo "Usage: proj open <name>"; return 2; }
      local d="${PROJECT_ROOT%/}/$target"
      [[ -d "$d" ]] || { echo "Not found: $d"; return 1; }
      cd "$d" || return 1
      echo "$d" > "$HOME/.current_automation_project"
      [[ -n ${ZSH_VERSION-} && -f "$HOME/.zshrc" ]] && source "$HOME/.zshrc"
      ;;
    tmux)
      local name="${2:-}"; [[ -n "$name" ]] || { echo "Usage: proj tmux <name>"; return 2; }
      [[ -d "${PROJECT_ROOT%/}/$name" ]] || { echo "Not found: ${PROJECT_ROOT%/}/$name"; return 1; }
      tmux has-session -t "$name" 2>/dev/null || tmux new-session -ds "$name" -c "${PROJECT_ROOT%/}/$name"
      tmux attach -t "$name"
      ;;
    *) "$PROJ_BIN" "$@";;
  esac
}

# Auto-update .clinerules on shell start (if >1 hour old)
if [ ! -f /root/.clinerules ] || [ $(find /root/.clinerules -mmin +60 2>/dev/null | wc -l) -gt 0 ]; then
    /root/.clinerules_generator.sh 2>/dev/null
fi

# Convenience alias to manually update resource rules
alias update-clinerules='/root/.clinerules_generator.sh'

# LAPD security analysis alias
alias lapd-report='/root/Desktop/Projects/LAPD/core/lapd_motd.sh'

# Display Keeper Security MOTD on login (only for interactive shells)
if [ -n "$PS1" ] && [ -f /root/.keeper_motd.sh ]; then
    /root/.keeper_motd.sh
fi

# Quick "where am I?" command - shows server location banner
whereami() {
    local PUBLIC_IP=$(curl -s --max-time 2 ifconfig.me 2>/dev/null || echo 'N/A')
    echo ""
    echo -e "\033[44m\033[1;37m                                                                                \033[0m"
    echo -e "\033[44m\033[1;37m  SERVER: $(hostname)  │  LOCATION: Portsmouth, UK  │  IP: ${PUBLIC_IP}  \033[0m"
    echo -e "\033[44m\033[1;37m                                                                                \033[0m"
    echo ""
    echo -e "  \033[0;36mCurrent Directory:\033[0m $PWD"
    echo ""
}
alias where='whereami'

# Claude tmux auto-start (DISABLED by default - enable with: claude-autostart on)
# Only runs in interactive shells, not in scripts or automation
if [ "$CLAUDE_AUTOSTART" = "1" ] && [ -n "$PS1" ] && [ -z "$TMUX" ] && [ -t 0 ]; then
    # Only auto-start if no Claude tmux sessions exist and not already in tmux
    if ! tmux ls 2>/dev/null | grep -q "claude"; then
        echo ""
        echo -e "\033[1;33m🤖 Auto-starting Claude in tmux...\033[0m"
        echo -e "\033[0;33m   (Disable with: claude-autostart off)\033[0m"
        sleep 2
        claude-tmux
    fi
fi

# Quick command to enable/disable auto-start
claude-autostart() {
    case "${1:-status}" in
        on|enable)
            echo "export CLAUDE_AUTOSTART=1" >> ~/.zshrc
            export CLAUDE_AUTOSTART=1
            echo -e "\033[1;32m✅ Claude auto-start enabled\033[0m"
            echo "Claude will auto-start in tmux on next shell login"
            ;;
        off|disable)
            sed -i '/export CLAUDE_AUTOSTART=1/d' ~/.zshrc
            export CLAUDE_AUTOSTART=0
            echo -e "\033[1;33m⚠️  Claude auto-start disabled\033[0m"
            ;;
        status)
            if [ "$CLAUDE_AUTOSTART" = "1" ]; then
                echo -e "\033[1;32m✅ Claude auto-start: ENABLED\033[0m"
            else
                echo -e "\033[0;33m⚪ Claude auto-start: DISABLED\033[0m"
                echo "Enable with: claude-autostart on"
            fi
            ;;
        *)
            echo "Usage: claude-autostart [on|off|status]"
            ;;
    esac
}

export PATH="$HOME/.local/bin:$PATH"
