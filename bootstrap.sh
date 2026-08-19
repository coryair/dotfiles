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

nix_path=$(command -v nix || true)

if [ -z "$nix_path" ]; then
  installer=/tmp/lix-installer.sh
  curl -fsSL https://install.lix.systems/lix -o "$installer"
  sh "$installer" install
  nix_path=/nix/var/nix/profiles/default/bin/nix
fi

if [ ! -x "$nix_path" ]; then
  echo "Nix installation completed, but the nix executable was not found." >&2
  exit 1
fi

sudo "$nix_path" \
  --extra-experimental-features "nix-command flakes" \
  run github:nix-darwin/nix-darwin/master#darwin-rebuild -- \
  switch --flake "$config_dir#$configuration"
