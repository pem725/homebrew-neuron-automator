class NeuronAutomator < Formula
  desc "Automated Neuron Daily newsletter reader with intelligent scheduling"
  homepage "https://github.com/pem725/NeuronAutomator"
  url "https://github.com/pem725/NeuronAutomator/archive/refs/tags/v1.5.0.tar.gz"
  sha256 "" # Will be calculated when you create the release
  license "MIT"
  head "https://github.com/pem725/NeuronAutomator.git", branch: "main"

  # System dependencies
  depends_on "python@3.11"
  depends_on "python@3.12" => :optional
  
  # Chrome is required but installed via cask
  # We'll check for it in the install process

  def install
    # Determine Python version to use
    python = which("python3.12") || which("python3.11") || which("python3")
    unless python
      odie "Python 3.11+ is required but not found"
    end

    python_version = Utils.safe_popen_read(python, "--version").strip.match(/\d+\.\d+/)[0]
    unless Gem::Version.new(python_version) >= Gem::Version.new("3.8")
      odie "Python #{python_version} is too old. Python 3.8+ required."
    end

    # Create installation directory structure
    libexec.install Dir["*"]
    
    # Create Python virtual environment in libexec
    system python, "-m", "venv", libexec/"venv"
    venv_python = libexec/"venv/bin/python"
    venv_pip = libexec/"venv/bin/pip"
    
    # Upgrade pip and install requirements
    system venv_pip, "install", "--upgrade", "pip", "setuptools", "wheel"
    system venv_pip, "install", "-r", libexec/"requirements.txt"
    
    # Install webdriver-manager which handles ChromeDriver
    system venv_pip, "install", "webdriver-manager"

    # Create the main executable wrapper
    (bin/"neuron-automation").write <<~EOS
      #!/bin/bash
      
      # Set up environment
      export PATH="#{libexec}/venv/bin:$PATH"
      export PYTHONPATH="#{libexec}:$PYTHONPATH"
      
      # Check for Chrome
      if ! command -v "Google Chrome" &> /dev/null && ! [ -d "/Applications/Google Chrome.app" ]; then
        echo "⚠️  Google Chrome not found. Please install Chrome:"
        echo "   brew install --cask google-chrome"
        exit 1
      fi
      
      # Run the automation
      exec "#{venv_python}" "#{libexec}/neuron_automation.py" "$@"
    EOS

    # Create blacklist-rewind executable wrapper
    (bin/"blacklist-rewind").write <<~EOS
      #!/bin/bash
      
      # Set up environment  
      export PATH="#{libexec}/venv/bin:$PATH"
      export PYTHONPATH="#{libexec}:$PYTHONPATH"
      
      # Run the blacklist rewind tool
      exec "#{venv_python}" "#{libexec}/blacklist_rewind.py" "$@"
    EOS

    # Make executables
    chmod 0755, bin/"neuron-automation"
    chmod 0755, bin/"blacklist-rewind"

    # Install configuration template
    (share/"neuron-automator").install libexec/"config.py" => "config.template.py"
    
    # Install documentation
    doc.install "README.md"
    doc.install "BLACKLIST_REWIND_USAGE.md"
    doc.install "TODO.md"
  end

  def post_install
    # Create config directory
    config_dir = Pathname.new("#{ENV["HOME"]}/.config/neuron-automation")
    config_dir.mkpath
    
    # Copy files to user config if they don't exist
    unless (config_dir/"config.py").exist?
      cp "#{share}/neuron-automator/config.template.py", config_dir/"config.py"
    end

    unless (config_dir/"link_manager.py").exist?
      cp "#{libexec}/link_manager.py", config_dir/"link_manager.py"
    end

    unless (config_dir/"blacklist_rewind.py").exist?
      cp "#{libexec}/blacklist_rewind.py", config_dir/"blacklist_rewind.py"
    end

    # Create data and logs directories
    (config_dir/"data").mkpath
    (config_dir/"logs").mkpath

    # Set up launchd for automatic scheduling
    setup_launchd_service(config_dir)
  end

  def setup_launchd_service(config_dir)
    # Create launchd plist for automatic scheduling
    launch_agents_dir = Pathname.new("#{ENV["HOME"]}/Library/LaunchAgents")
    launch_agents_dir.mkpath
    
    plist_file = launch_agents_dir/"com.neuron.automation.plist"
    
    plist_content = <<~XML
      <?xml version="1.0" encoding="UTF-8"?>
      <!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
      <plist version="1.0">
      <dict>
        <key>Label</key>
        <string>com.neuron.automation</string>
        <key>ProgramArguments</key>
        <array>
          <string>#{HOMEBREW_PREFIX}/bin/neuron-automation</string>
        </array>
        <key>StartCalendarInterval</key>
        <array>
          <dict>
            <key>Weekday</key><integer>1</integer>
            <key>Hour</key><integer>5</integer><key>Minute</key><integer>30</integer>
          </dict>
          <dict>
            <key>Weekday</key><integer>1</integer>
            <key>Hour</key><integer>6</integer><key>Minute</key><integer>0</integer>
          </dict>
          <dict>
            <key>Weekday</key><integer>1</integer>
            <key>Hour</key><integer>6</integer><key>Minute</key><integer>30</integer>
          </dict>
          <dict>
            <key>Weekday</key><integer>1</integer>
            <key>Hour</key><integer>7</integer><key>Minute</key><integer>0</integer>
          </dict>
          <dict>
            <key>Weekday</key><integer>2</integer>
            <key>Hour</key><integer>5</integer><key>Minute</key><integer>30</integer>
          </dict>
          <dict>
            <key>Weekday</key><integer>2</integer>
            <key>Hour</key><integer>6</integer><key>Minute</key><integer>0</integer>
          </dict>
          <dict>
            <key>Weekday</key><integer>2</integer>
            <key>Hour</key><integer>6</integer><key>Minute</key><integer>30</integer>
          </dict>
          <dict>
            <key>Weekday</key><integer>2</integer>
            <key>Hour</key><integer>7</integer><key>Minute</key><integer>0</integer>
          </dict>
          <dict>
            <key>Weekday</key><integer>3</integer>
            <key>Hour</key><integer>5</integer><key>Minute</key><integer>30</integer>
          </dict>
          <dict>
            <key>Weekday</key><integer>3</integer>
            <key>Hour</key><integer>6</integer><key>Minute</key><integer>0</integer>
          </dict>
          <dict>
            <key>Weekday</key><integer>3</integer>
            <key>Hour</key><integer>6</integer><key>Minute</key><integer>30</integer>
          </dict>
          <dict>
            <key>Weekday</key><integer>3</integer>
            <key>Hour</key><integer>7</integer><key>Minute</key><integer>0</integer>
          </dict>
          <dict>
            <key>Weekday</key><integer>4</integer>
            <key>Hour</key><integer>5</integer><key>Minute</key><integer>30</integer>
          </dict>
          <dict>
            <key>Weekday</key><integer>4</integer>
            <key>Hour</key><integer>6</integer><key>Minute</key><integer>0</integer>
          </dict>
          <dict>
            <key>Weekday</key><integer>4</integer>
            <key>Hour</key><integer>6</integer><key>Minute</key><integer>30</integer>
          </dict>
          <dict>
            <key>Weekday</key><integer>4</integer>
            <key>Hour</key><integer>7</integer><key>Minute</key><integer>0</integer>
          </dict>
          <dict>
            <key>Weekday</key><integer>5</integer>
            <key>Hour</key><integer>5</integer><key>Minute</key><integer>30</integer>
          </dict>
          <dict>
            <key>Weekday</key><integer>5</integer>
            <key>Hour</key><integer>6</integer><key>Minute</key><integer>0</integer>
          </dict>
          <dict>
            <key>Weekday</key><integer>5</integer>
            <key>Hour</key><integer>6</integer><key>Minute</key><integer>30</integer>
          </dict>
          <dict>
            <key>Weekday</key><integer>5</integer>
            <key>Hour</key><integer>7</integer><key>Minute</key><integer>0</integer>
          </dict>
        </array>
        <key>StandardOutPath</key>
        <string>#{config_dir}/logs/launchd.out.log</string>
        <key>StandardErrorPath</key>
        <string>#{config_dir}/logs/launchd.err.log</string>
        <key>RunAtLoad</key>
        <false/>
      </dict>
      </plist>
    XML

    File.write(plist_file, plist_content)
    
    # Load the launchd service
    system "launchctl", "unload", plist_file if File.exist?(plist_file)
    system "launchctl", "load", plist_file
  end

  test do
    # Test that the executables exist and can show version
    assert_match "neuron-automation", shell_output("#{bin}/neuron-automation --version")
    
    # Test configuration file creation
    system "#{bin}/neuron-automation", "--help"
  end

  def caveats
    <<~EOS
      Neuron Automator has been installed successfully! 🎉
      
      📋 SETUP COMPLETE:
      ✅ Automatic scheduling configured for weekday mornings (5:30, 6:00, 6:30, 7:00 AM)
      ✅ Configuration created at ~/.config/neuron-automation/
      ✅ Command-line tools installed: neuron-automation, blacklist-rewind
      
      🚀 QUICK START:
      1. Install Chrome if not already installed:
         brew install --cask google-chrome
      
      2. Test the installation:
         neuron-automation
      
      3. View your reading statistics:
         neuron-automation --stats
      
      4. Use the time rewind feature:
         neuron-automation --rewind-preview 7
      
      📖 USAGE:
      • Manual run:        neuron-automation
      • Check for updates: neuron-automation --check-updates  
      • Update system:     neuron-automation --update
      • View logs:         tail -f ~/.config/neuron-automation/logs/neuron_automation.log
      • Blacklist rewind:  blacklist-rewind --help
      
      🔧 LAUNCHD SERVICE:
      • Check status:      launchctl list | grep neuron
      • Disable service:   launchctl unload ~/Library/LaunchAgents/com.neuron.automation.plist
      • Re-enable:         launchctl load ~/Library/LaunchAgents/com.neuron.automation.plist
      
      📚 DOCUMENTATION:
      • README:            brew --prefix neuron-automator/share/doc/README.md
      • Time Rewind Guide: brew --prefix neuron-automator/share/doc/BLACKLIST_REWIND_USAGE.md
      
      🆘 SUPPORT:
      If you encounter issues, check the logs and visit:
      https://github.com/pem725/NeuronAutomator/issues
      
      The automation will start working on your next weekday morning!
    EOS
  end
end