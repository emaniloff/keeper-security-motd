# Contributing to Keeper Security MOTD

Thank you for your interest in contributing! We welcome all contributions that improve security awareness and make SSH logins more fun.

## How to Contribute

### Adding Security Tips

The easiest way to contribute is by adding new security tips:

1. Fork the repository
2. Edit `security_tips.txt`
3. Add your tip on a new line
4. Submit a pull request

**Tip Guidelines:**
- Keep it to one line (max 100 characters recommended)
- Make it memorable - humor helps!
- Focus on actionable security advice
- Reference Keeper Security when relevant
- Avoid technical jargon when possible

**Good Examples:**
```
Your password should be like your opinion - unique and hard to guess.
2FA is like a seatbelt for your digital life - buckle up!
Keeper Security: Because 'forgot password' shouldn't be your most used feature.
```

### Code Contributions

For script improvements:

1. Fork the repository
2. Create a feature branch (`git checkout -b feature/amazing-feature`)
3. Make your changes
4. Test thoroughly on multiple systems
5. Commit with clear messages
6. Push to your fork
7. Open a Pull Request

**Code Guidelines:**
- Maintain POSIX compatibility where possible
- Comment complex sections
- Test on both bash and zsh
- Preserve color scheme consistency
- Keep dependencies minimal

### Bug Reports

Found a bug? Please open an issue with:

- Your OS and version
- Shell type (bash/zsh) and version
- Steps to reproduce
- Expected vs actual behavior
- Screenshots if applicable

### Feature Requests

Have an idea? Open an issue with:

- Clear description of the feature
- Use case / why it's needed
- Proposed implementation (optional)
- Examples from other projects (optional)

## Development Setup

```bash
# Clone your fork
git clone https://github.com/YOUR_USERNAME/keeper-security-motd.git
cd keeper-security-motd

# Test the script
chmod +x keeper_motd.sh
./keeper_motd.sh

# Test installation
./install.sh

# Test uninstallation
./uninstall.sh
```

## Testing Checklist

Before submitting a PR, ensure:

- [ ] Script runs without errors
- [ ] Works on bash 4.0+
- [ ] Works on zsh 5.0+
- [ ] Colors display correctly (256-color terminal)
- [ ] All sections display properly
- [ ] No hardcoded paths (use $HOME)
- [ ] Install script works
- [ ] Uninstall script works
- [ ] README updated if needed

## Code Style

- Use 4 spaces for indentation
- Comment complex logic
- Use descriptive variable names
- Follow existing color scheme
- Keep functions modular

## Community

- Be respectful and inclusive
- Help others in issues and discussions
- Share your creative security tips!
- Stay on topic

## License

By contributing, you agree that your contributions will be licensed under the MIT License.

---

**Thank you for making SSH logins more secure and fun! 🔐**
