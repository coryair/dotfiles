# macOS configuration

Declarative Apple Silicon macOS configuration built with nix-darwin and Home Manager. It uses [dreamsofautonomy/nix-darwin](https://github.com/dreamsofautonomy/nix-darwin) as its starting point, updated for current nix-darwin and extended with Home Manager for user-level configuration.

There is no chezmoi, Homebrew module, or Brewfile in this repository.

## What is managed

- Nix and Lix settings
- macOS Dock, Finder, keyboard, login, and time-zone defaults
- CLI packages
- Git, Neovim, tmux, and Zsh user configuration through Home Manager
- Separate host identities for the VM and the physical Mac

## Apply to the VM

Clone this repository inside the VM, then run:

```sh
./bootstrap.sh macos-vm
```

The VM profile expects the user `cory` and sets the hostname to `macos-config-vm`.

## Apply to the physical Mac

```sh
./bootstrap.sh macbook
```

The physical Mac profile expects the user `cory.hernandez` and sets the hostname to `cory-mac`.

## Make and apply changes

Edit the Nix files, then run the matching profile:

```sh
sudo darwin-rebuild switch --flake .#macos-vm
```

Update pinned dependencies deliberately:

```sh
nix flake update
```

Rollback remains available through previous nix-darwin generations:

```sh
darwin-rebuild --list-generations
sudo darwin-rebuild --rollback
```
