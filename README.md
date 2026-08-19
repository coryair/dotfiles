# Machine configuration

Declarative macOS and Linux configuration built with Nix, nix-darwin, and Home Manager. It uses [dreamsofautonomy/nix-darwin](https://github.com/dreamsofautonomy/nix-darwin) as its starting point, updated for current nix-darwin and extended to configure user environments on Linux.

There is no chezmoi, Homebrew module, or Brewfile in this repository.

## Bootstrap a machine

Clone or extract this repository, then run one command as your normal user:

```sh
./bootstrap.sh
```

Do not pass a machine name. The script detects:

- macOS or Linux
- Apple Silicon, ARM64 Linux, Intel Mac, or x86-64 Linux
- The current username, home directory, and hostname
- Whether Lix is absent, already active, or installed outside the current `PATH`

On macOS it applies nix-darwin and Home Manager. On Linux it applies Home Manager. The Lix installer and macOS activation request sudo when needed; Linux Home Manager activation runs as the current user.

## What is managed everywhere

- CLI packages
- Git defaults
- Neovim
- tmux
- Zsh completion, autosuggestions, syntax highlighting, aliases, and environment variables

## What is additionally managed on macOS

- Nix and Lix daemon settings
- Dock, Finder, keyboard, login, and time-zone defaults
- System Git and jq packages

## Make and apply changes

Edit the Nix files and rerun:

```sh
./bootstrap.sh
```

Update pinned dependencies deliberately:

```sh
nix flake update
```

On macOS, previous nix-darwin generations remain available:

```sh
darwin-rebuild --list-generations
sudo darwin-rebuild --rollback
```
