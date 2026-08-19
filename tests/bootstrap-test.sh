#!/bin/sh
# shellcheck disable=SC2016
set -eu

repo_dir=$(CDPATH='' cd -- "$(dirname -- "$0")/.." && pwd)
work_dir=$(mktemp -d "${TMPDIR:-/tmp}/macos-bootstrap-test.XXXXXX")
trap 'rm -rf "$work_dir"' EXIT

mkdir "$work_dir/bin"

printf '%s\n' '#!/bin/sh' 'case "$1" in' \
  '  -s) echo Darwin ;;' \
  '  -m) echo arm64 ;;' \
  '  *) /usr/bin/uname "$@" ;;' \
  'esac' > "$work_dir/bin/uname"

printf '%s\n' '#!/bin/sh' \
  'while [ "$#" -gt 0 ]; do' \
  '  if [ "$1" = "-o" ]; then' \
  '    shift' \
  '    : > "$1"' \
  '  fi' \
  '  shift' \
  'done' > "$work_dir/bin/curl"

printf '%s\n' '#!/bin/sh' 'exit 0' > "$work_dir/bin/sh"
printf '%s\n' '#!/bin/sh' 'exec "$@"' > "$work_dir/bin/sudo"
printf '%s\n' '#!/bin/sh' "printf '%s\\n' \"\$*\" > '$work_dir/nix-args'" > "$work_dir/installed-nix"

printf '%s\n' \
  'check_nix_profiles() {' \
  '  if [ -n "$ZSH_VERSION" ]; then' \
  '    :' \
  '  fi' \
  '}' \
  'check_nix_profiles' > "$work_dir/nix-daemon.sh"

chmod +x "$work_dir/bin/uname" "$work_dir/bin/curl" "$work_dir/bin/sh" \
  "$work_dir/bin/sudo" "$work_dir/installed-nix"

sed \
  -e "s|/nix/var/nix/profiles/default/etc/profile.d/nix-daemon.sh|$work_dir/nix-daemon.sh|g" \
  -e "s|/nix/var/nix/profiles/default/bin/nix|$work_dir/installed-nix|g" \
  "$repo_dir/bootstrap.sh" > "$work_dir/bootstrap.sh"
chmod +x "$work_dir/bootstrap.sh"

PATH="$work_dir/bin:/usr/bin:/bin" "$work_dir/bootstrap.sh" macos-vm

grep -F "switch --flake $work_dir#macos-vm" "$work_dir/nix-args" >/dev/null
