{
  config,
  pkgs,
  ...
}: {
  programs.zsh.enable = true;
  environment.shells = [pkgs.bash pkgs.zsh];
  environment.loginShell = pkgs.zsh;
  nix.extraOptions = ''
    experimental-features = nix-command flakes
  '';
  # Enable nix-darwin system modules
  services = {
    # Enable system services like `ssh`, `ntp`, etc.
    # sshd.enable = true;
    # You can add more services here as needed
    nix-daemon.enable = true;
  };

  # Configure system-wide packages
  environment.systemPackages = with pkgs; [
    wget
    htop
    # (pkgs.mkShell {
    #   buildInputs = [ pkgs.git ];
    # })
  ];

  system = {
    stateVersion = 5;

    keyboard = {
      remapCapsLockToControl = true;
      enableKeyMapping = true;
    };

    defaults = {
      finder.AppleShowAllExtensions = true;
      finder._FXShowPosixPathInTitle = true;
      dock.autohide = true;
      NSGlobalDomain.AppleShowAllExtensions = true;
      #NSGlobalDomain.InitialKeyRepeat = 5;
      #NSGlobalDomain.KeyRepeat = 1;
      menuExtraClock.ShowSeconds = true;
    };
  };
  # fonts.fontDir.enable = false;
  # fonts.fonts = [ pkgs.nerdfonts.override { fonts = ["JetBrainsMono" "NerdFontsSymbolsOnly"]; }];

  system.activationScripts.postUserActivation.text = ''
    # Following line should allow us to avoid a logout/login cycle
    /System/Library/PrivateFrameworks/SystemAdministration.framework/Resources/activateSettings -u
  '';
  # Other macOS-specific configurations, e.g., enabling FileVault, Dock settings
  # programs.dock = {
  #   enable = true;
  # };
}
