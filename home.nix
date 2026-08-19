{
  pkgs,
  userName,
  homeDirectory,
  ...
}:

{
  home = {
    username = userName;
    inherit homeDirectory;
    stateVersion = "26.05";

    packages = with pkgs; [
      bat
      fd
      fzf
      ripgrep
      tmux
    ];

    sessionVariables = {
      EDITOR = "nvim";
      VISUAL = "nvim";
    };
  };

  programs = {
    home-manager.enable = true;

    git = {
      enable = true;
      settings = {
        init.defaultBranch = "main";
        pull.rebase = true;
      };
    };

    neovim = {
      enable = true;
      defaultEditor = true;
      viAlias = true;
      vimAlias = true;
    };

    zsh = {
      enable = true;
      autosuggestion.enable = true;
      enableCompletion = true;
      syntaxHighlighting.enable = true;

      shellAliases = {
        ll = "ls -lah";
        rebuild-config = "$HOME/.config/nix-darwin/bootstrap.sh";
      };
    };
  };
}
