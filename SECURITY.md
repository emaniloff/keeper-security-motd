# Security Guidelines

## 🔐 Credential Management

### **NEVER** commit credentials to version control!

This repository uses environment variables for sensitive configuration. Follow these practices:

## ✅ Best Practices

### 1. Use Environment Variables

**❌ DON'T:**
```bash
# .bashrc
export SECURITY_NEXUS_API_KEY="snx-W2jHfjJXyZCc6cXb6q-Ks94c8RRZAniFyrlWrGkuzEE"
```

**✅ DO:**
```bash
# .bashrc
if [ -f "$HOME/.env" ]; then
    source "$HOME/.env"
fi

# .env (NOT committed to git)
export SECURITY_NEXUS_API_KEY="your-actual-key-here"
```

### 2. Use the Template

```bash
# Copy the example template
cp .env.example .env

# Edit with your credentials
nano .env

# The .env file is automatically ignored by git
```

### 3. Protected Files

The `.gitignore` automatically protects these patterns:
- `.env*` files (except `.env.example`)
- `*_api_key*`, `*_token*`, `*_secret*`
- `credentials.*`, `secrets.*`
- All common credential file patterns

### 4. For Keeper Security MOTD

This is a **public repository** with security-themed content. Extra care must be taken:

1. **No hardcoded API keys** in shell configs
2. **No real credentials** in example files
3. **Use placeholders** in documentation
4. **Rotate any exposed keys** immediately

## 🚨 If Credentials Are Exposed

1. **Immediately rotate/revoke** the exposed credentials
2. **Remove from git history** (not just delete the file)
3. **Update `.gitignore`** if the pattern wasn't caught
4. **Notify relevant teams** if enterprise keys were exposed

### Remove from Git History

```bash
# Remove sensitive file from all commits
git filter-branch --force --index-filter \
  "git rm --cached --ignore-unmatch path/to/sensitive/file" \
  --prune-empty --tag-name-filter cat -- --all

# Force push (coordinate with team first!)
git push origin --force --all
```

## 🛡️ Repository-Specific Guidelines

### Shell Configuration Files (.bashrc, .zshrc)

If sharing shell configs in this repo:
- Use `$HOME` instead of hardcoded paths
- Reference `.env` files, don't hardcode secrets
- Include clear comments about what needs configuration
- Provide `.example` versions of any config files

### MOTD Scripts

The Keeper Security MOTD scripts should:
- Only display **public** system information
- Never expose credentials in output
- Use secure file permissions (0600 for sensitive files)
- Validate all user inputs

## 📋 Pre-Commit Checklist

Before committing code, verify:
- [ ] No API keys or tokens in code
- [ ] No hardcoded passwords
- [ ] No private keys (.pem, .key files)
- [ ] No credential files
- [ ] `.env` is in `.gitignore`
- [ ] Only `.env.example` with placeholders is committed

## 🔍 Scanning Tools

Consider using these tools to detect secrets:

```bash
# Git-secrets (AWS)
git secrets --scan

# Gitleaks
gitleaks detect --source .

# TruffleHog
trufflehog filesystem .
```

## 📞 Report Security Issues

If you find security vulnerabilities or exposed credentials:

1. **DO NOT** open a public GitHub issue
2. Contact the repository maintainer privately
3. Provide details about the exposure
4. Allow time for remediation before disclosure

---

**Remember: This is a security-themed repository. We must lead by example!** 🔐
