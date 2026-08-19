#!/bin/sh
set -eu

configuration="${1:-macos-vm}"
config_dir=$(CDPATH='' cd -- "$(dirname -- "$0")" && pwd)

if [ "$(uname -s)" != "Darwin" ]; then
  echo "This bootstrap script must run on macOS." >&2
  exit 1
fi

if [ "$(uname -m)" != "arm64" ]; then
  echo "This configuration currently supports Apple Silicon only." >&2
  exit 1
fi

if ! command -v nix >/dev/null 2>&1; then
  installer=/tmp/lix-installer.sh
  curl -fsSL https://install.lix.systems/lix -o "$installer"
  sh "$installer" install
fi

if [ -f /nix/var/nix/profiles/default/etc/profile.d/nix-daemon.sh ]; then
  # shellcheck source=/dev/null
  . /nix/var/nix/profiles/default/etc/profile.d/nix-daemon.sh
fi

nix_path=$(command -v nix)

sudo "$nix_path" \
  --extra-experimental-features "nix-command flakes" \
  run github:nix-darwin/nix-darwin/master#darwin-rebuild -- \
  switch --flake "$config_dir#$configuration"
