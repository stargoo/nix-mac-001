{
  pkgs,
  pkgs-unstable,
  ...
}: {
  home.username = "scott"; # REPLACE ME
  home.homeDirectory = "/Users/scott"; # REPLACE ME
  home.stateVersion = "24.05";

  programs.home-manager.enable = true;

  home.packages = with pkgs; [
    pkgs-unstable.neovim
    pkgs-unstable.oh-my-posh
    sl
    tmux
    eza
    glow
    alejandra
    tldr
    asciinema
    fd
    wget
    rename
  ];

  home.file = {
    ".config/oh-my-posh/config.json" = {
      source = ../config/oh-my-posh/config.json;
      target = ".config/oh-my-posh/config.json";
    };
  };

  programs.fzf = {
      enable = true;
      enableZshIntegration = true;
  };

  programs.fd = {
    enable = true;
    hidden = true;
  };

  programs.bat = {
    enable = true;
    extraPackages = with pkgs.bat-extras; [
      batman
    ];
    themes = {
      dracula = {
        src = pkgs.fetchFromGitHub {
          owner = "dracula";
          repo = "sublime"; # Bat uses sublime syntax for its themes
          rev = "26c57ec282abcaa76e57e055f38432bd827ac34e";
          sha256 = "019hfl4zbn4vm4154hh3bwk6hm7bdxbr1hdww83nabxwjn99ndhv";
        };
        file = "Dracula.tmTheme";
      };
      catppuccin = {
        src = pkgs.fetchFromGitHub {
          owner = "catppuccin";
          repo = "bat"; # Bat uses sublime syntax for its themes
          rev = "d3feec47b16a8e99eabb34cdfbaa115541d374fc";
          sha256 = "s0CHTihXlBMCKmbBBb8dUhfgOOQu9PBCQ+uviy7o47w=";
        };
        file = "themes/Catppuccin Mocha.tmTheme";
      };
    };
    config = {
      theme = "catppuccin";
      pager = "less -FR";
    };
  };

  programs.ripgrep = {
    enable = true;
    arguments = [
      "--hidden"
    ];
  };

  programs.git = {
    enable = true;
    includes = [
      {
        path = ../dotfiles/gitconfig;
      }
    ];
    delta = {
      enable = true;
      options = {
        navigate = true;
        light = false;
        side-by-side = true;
        line-numbers = true;
        decorations = {
          commit-decoration-style = "bold yellow box ul";
          file-decoration-style = "none";
          file-style = "bold yellow ul";
        };
        features = "decorations";
        whitespace-error-style = "22 reverse";
      };
    };
  };

  programs.zsh = {
    enable = true;
    initExtra = builtins.readFile ../dotfiles/zshrc;
    shellAliases = {
      ls="eza --long --icons";
      tree="eza --tree";
      vim="nvim";
      c="clear";
      cat="bat";
      gitcom="git commit -F- <<EOF";
      man="batman";
      archive="ua";
      config="git --git-dir=$HOME/.cfg --work-tree=$HOME";
    };
  };

  programs.zoxide = {
    enable = true;
  };

  programs.tmux = {
    enable = true;
    mouse = true;
    prefix = "C-a";
    baseIndex = 1;
    keyMode = "vi";
    extraConfig = builtins.readFile ../config/tmux/extra.conf;
    plugins = with pkgs; [
      {
        plugin = tmuxPlugins.sensible;
      }
      {
        plugin = tmuxPlugins.vim-tmux-navigator;
      }
      {
        plugin = tmuxPlugins.yank;
      }
      {
        plugin = tmuxPlugins.catppuccin;
        extraConfig = "set -g @catppuccin_flavour 'mocha' ";
      }
    ];
  };
}
