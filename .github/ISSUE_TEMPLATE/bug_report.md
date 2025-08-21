---
name: Bug report
about: Create a report to help us improve the Homebrew formula
title: '[BUG] '
labels: 'bug'
assignees: ''
---

**Describe the bug**
A clear and concise description of what the bug is.

**Environment**
- macOS version: [e.g. macOS 14.0]
- Homebrew version: [run `brew --version`]
- Neuron Automator version: [run `neuron-automation --version`]
- Installation method: [tap install / local build / etc.]

**To Reproduce**
Steps to reproduce the behavior:
1. Run command '...'
2. See error '...'

**Expected behavior**
A clear and concise description of what you expected to happen.

**Logs**
If applicable, include relevant log output:
```
# Homebrew logs
brew install --verbose neuron-automator

# Application logs  
tail -20 ~/.config/neuron-automation/logs/neuron_automation.log

# launchd logs
tail -20 ~/.config/neuron-automation/logs/launchd.err.log
```

**Additional context**
Add any other context about the problem here.