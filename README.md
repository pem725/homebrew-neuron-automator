# Homebrew Neuron Automator

A Homebrew tap for [Neuron Daily Newsletter Automation](https://github.com/pem725/NeuronAutomator) - the intelligent system that automatically opens your daily Neuron newsletter with all article links in browser tabs every weekday morning.

## Installation

### Prerequisites
- macOS 10.14+ (Mojave or later)  
- [Homebrew](https://brew.sh/) installed
- Google Chrome (will be installed automatically if missing)

### Install Neuron Automator

```bash
# Add the tap
brew tap pem725/neuron-automator

# Install the package
brew install neuron-automator

# Install Chrome if not already installed
brew install --cask google-chrome
```

That's it! The system is now configured and will run automatically every weekday morning.

## Usage

### Basic Commands
```bash
# Test the installation
neuron-automation

# Check your reading statistics  
neuron-automation --stats

# View available commands
neuron-automation --help

# Use the time rewind feature
neuron-automation --rewind-preview 7
blacklist-rewind --help
```

### System Management
```bash
# Check if the service is loaded
launchctl list | grep neuron

# View logs
tail -f ~/.config/neuron-automation/logs/neuron_automation.log

# Update to latest version
brew upgrade neuron-automator

# Temporarily disable automation
launchctl unload ~/Library/LaunchAgents/com.neuron.automation.plist

# Re-enable automation
launchctl load ~/Library/LaunchAgents/com.neuron.automation.plist
```

## What Gets Installed

### 🔧 System Integration
- **Automatic Scheduling**: launchd service runs weekday mornings (5:30, 6:00, 6:30, 7:00 AM)
- **Configuration**: `~/.config/neuron-automation/` with all settings and data
- **Executables**: `neuron-automation` and `blacklist-rewind` in your PATH
- **Dependencies**: Python virtual environment with all required packages

### 📁 File Locations
```
/opt/homebrew/bin/                     # Executables
├── neuron-automation                  # Main automation command
└── blacklist-rewind                   # Time rewind tool

~/.config/neuron-automation/           # User configuration
├── config.py                          # Main configuration file
├── link_manager.py                    # Link management system  
├── blacklist_rewind.py                # Time rewind functionality
├── data/                              # SQLite databases
└── logs/                              # Application logs

~/Library/LaunchAgents/                # macOS scheduling
└── com.neuron.automation.plist        # Launch daemon configuration
```

## Features

### ✨ Smart Multi-Run System
Multiple scheduled runs with intelligent change detection ensure perfect newsletter coverage without redundancy.

### 🔗 Advanced Link Management  
Sophisticated blacklist system prevents duplicate reading and provides detailed analytics on your reading patterns.

### ⏰ Time Rewind Tool
Go back in time to restore previously blacklisted content for re-learning and experimentation.

### 🌐 Chrome Integration
Seamless browser integration with persistence - tabs stay open after automation completes for reading at your own pace.

### 🛡️ Cross-Platform Shell Support
Auto-detects and configures zsh, bash, and other shells with Oh My Zsh support.

## Troubleshooting

### Installation Issues
```bash
# Check Homebrew installation
brew doctor

# Reinstall if needed
brew uninstall neuron-automator
brew install neuron-automator

# Check dependencies
brew list | grep python
ls -la /Applications/ | grep Chrome
```

### Service Issues
```bash
# Check service status
launchctl list | grep neuron

# View service errors
cat ~/.config/neuron-automation/logs/launchd.err.log

# Reload service
launchctl unload ~/Library/LaunchAgents/com.neuron.automation.plist
launchctl load ~/Library/LaunchAgents/com.neuron.automation.plist
```

### Browser Issues
```bash
# Check application logs
tail -20 ~/.config/neuron-automation/logs/neuron_automation.log

# Test Chrome integration
neuron-automation --test-browser

# Run with verbose output
neuron-automation --verbose
```

## Updating

### Automatic Updates
```bash
# Update to latest version
brew upgrade neuron-automator

# Update all Homebrew packages
brew upgrade
```

### Manual Update from Source
```bash
# If you need the absolute latest from GitHub
neuron-automation --update
```

## Uninstallation

### Remove Application Only
```bash
# Uninstall but keep configuration
brew uninstall neuron-automator
```

### Complete Removal
```bash
# Uninstall application
brew uninstall neuron-automator

# Remove configuration (optional)
rm -rf ~/.config/neuron-automation

# Remove launchd service
launchctl unload ~/Library/LaunchAgents/com.neuron.automation.plist
rm ~/Library/LaunchAgents/com.neuron.automation.plist

# Remove tap (optional)
brew untap pem725/neuron-automator
```

## Version History

See [CHANGELOG](https://github.com/pem725/NeuronAutomator/blob/main/TODO.md#-project-history--evolution) for detailed version history.

## Support

- 📖 **Documentation**: [Main Repository](https://github.com/pem725/NeuronAutomator)
- 🐛 **Issues**: [GitHub Issues](https://github.com/pem725/NeuronAutomator/issues)  
- 💬 **Discussions**: [GitHub Discussions](https://github.com/pem725/NeuronAutomator/discussions)

## Contributing

1. **Fork** the [main repository](https://github.com/pem725/NeuronAutomator)
2. **Test** your changes with this Homebrew tap
3. **Submit** pull requests to the main repository
4. **Formula updates** will be made automatically for releases

## License

MIT License - see the [main repository](https://github.com/pem725/NeuronAutomator/blob/main/LICENSE) for details.

---

<div align="center">

**🌅 Good morning! Your newsletter articles are ready to read.**

Made with ❤️ for the Neuron Daily community

</div>