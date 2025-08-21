# Setting Up Your Homebrew Tap

This guide walks you through creating your Homebrew tap repository on GitHub and preparing for your first release.

## Step 1: Create GitHub Repository

1. **Create New Repository**:
   - Go to https://github.com/new
   - Repository name: `homebrew-neuron-automator`
   - Description: "Homebrew tap for Neuron Daily Newsletter Automation"
   - Make it **Public** (required for Homebrew taps)
   - Don't initialize with README (we have our own)

2. **Push Local Repository**:
   ```bash
   cd /path/to/homebrew-neuron-automator
   git add .
   git commit -m "Initial Homebrew tap for neuron-automator"
   git remote add origin https://github.com/pem725/homebrew-neuron-automator.git
   git push -u origin main
   ```

## Step 2: Create Your First Release

Before users can install via Homebrew, you need a tagged release in your main repository:

1. **Tag a Release** in NeuronAutomator repository:
   ```bash
   cd /path/to/NeuronAutomator
   git tag v1.5.0
   git push origin v1.5.0
   ```

2. **Update Formula SHA256**:
   ```bash
   cd /path/to/homebrew-neuron-automator
   ./update-formula.sh v1.5.0
   ```

3. **Commit and Push Formula**:
   ```bash
   git add .
   git commit -m "Update to v1.5.0"
   git push origin main
   ```

## Step 3: Test the Tap

1. **Add Your Tap** (on a macOS machine):
   ```bash
   brew tap pem725/neuron-automator
   ```

2. **Install from Tap**:
   ```bash
   brew install neuron-automator
   ```

3. **Test Installation**:
   ```bash
   neuron-automation --version
   neuron-automation --help
   ```

## Step 4: Update Your Main Repository Documentation

Add Homebrew installation to your main NeuronAutomator README.md:

```markdown
## macOS Installation (Recommended)

### Homebrew (Easiest)
```bash
# Add the tap and install
brew tap pem725/neuron-automator
brew install neuron-automator

# Install Chrome if needed
brew install --cask google-chrome

# Test the installation
neuron-automation
```

### Manual Installation
```bash
git clone https://github.com/pem725/NeuronAutomator.git
cd NeuronAutomator
./installers/install_macos.sh
```
```

## Step 5: Automation Setup

### GitHub Actions (Already configured)
- Tests run automatically on macOS 13 and 14
- Formula validation on every push
- Weekly dependency checks

### Release Process
When you want to release a new version:

1. **Create Release** in main repo:
   ```bash
   cd NeuronAutomator
   git tag v1.5.1
   git push origin v1.5.1
   ```

2. **Update Homebrew Formula**:
   ```bash
   cd homebrew-neuron-automator
   ./update-formula.sh v1.5.1
   git add .
   git commit -m "Update to v1.5.1"
   git push origin main
   ```

3. **Users Update**:
   ```bash
   brew upgrade neuron-automator
   ```

## Troubleshooting

### Common Issues

**Formula Audit Fails**:
```bash
brew audit --strict --online ./Formula/neuron-automator.rb
```

**Installation Fails**:
```bash
brew install --build-from-source --verbose ./Formula/neuron-automator.rb
```

**Testing Locally**:
```bash
# Test without installing
brew test ./Formula/neuron-automator.rb

# Install and test
brew install --build-from-source ./Formula/neuron-automator.rb
neuron-automation --version
brew uninstall neuron-automator
```

### Debug Mode
Add `--verbose` to any brew command for detailed output:
```bash
brew install --verbose neuron-automator
```

## Next Steps

1. ✅ **Repository Created**: Push to GitHub
2. ✅ **First Release**: Create v1.5.0 tag and update formula  
3. ✅ **Test Installation**: Verify everything works
4. ✅ **Update Documentation**: Add Homebrew instructions to main README
5. 🚀 **Announce**: Let your users know about the new installation method!

## Maintenance

### Weekly Tasks
- Monitor GitHub Actions for test failures
- Check for dependency updates
- Review any user issues

### Per Release
- Run `./update-formula.sh <version>`
- Test installation locally
- Update documentation if needed

Your Homebrew tap is ready to make installation much easier for macOS users! 🍺