#!/usr/bin/env bash
#
# minvim bootstrap — set up this Neovim config on a fresh Linux box.
#
# Installs Neovim (from the official release tarball) plus the handful of
# CLI tools the config expects, then symlinks this directory to
# ~/.config/nvim and syncs plugins headlessly.
#
# Usage:
#   ./bootstrap.sh            # install everything and link the config
#   NVIM_VERSION=0.11.7 ./bootstrap.sh   # pin a specific Neovim version
#
# Re-running is safe (idempotent): existing installs are reused.

set -euo pipefail

NVIM_VERSION="${NVIM_VERSION:-0.11.7}"
NVIM_PREFIX="/usr/local"
CONFIG_DIR="${XDG_CONFIG_HOME:-$HOME/.config}/nvim"
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

log()  { printf '\033[1;32m==>\033[0m %s\n' "$*"; }
warn() { printf '\033[1;33m==>\033[0m %s\n' "$*" >&2; }
die()  { printf '\033[1;31m==>\033[0m %s\n' "$*" >&2; exit 1; }

[ "$(uname -s)" = "Linux" ] || die "This bootstrap targets Linux only."

# Use sudo only when we are not already root.
SUDO=""
if [ "$(id -u)" -ne 0 ]; then
  command -v sudo >/dev/null 2>&1 && SUDO="sudo" || die "Need root or sudo to install packages."
fi

# --- Detect the system package manager --------------------------------------

detect_pm() {
  for pm in apt-get dnf pacman zypper apk; do
    command -v "$pm" >/dev/null 2>&1 && { echo "$pm"; return; }
  done
  echo ""
}

PM="$(detect_pm)"

# Install the listed packages with whatever package manager we found.
pm_install() {
  [ "$#" -gt 0 ] || return 0
  case "$PM" in
    apt-get) $SUDO apt-get update -qq && $SUDO apt-get install -y "$@" ;;
    dnf)     $SUDO dnf install -y "$@" ;;
    pacman)  $SUDO pacman -Sy --needed --noconfirm "$@" ;;
    zypper)  $SUDO zypper install -y "$@" ;;
    apk)     $SUDO apk add "$@" ;;
    *)       warn "No supported package manager found; install these manually: $*" ;;
  esac
}

# --- Dependencies -----------------------------------------------------------
# git/curl/tar  : fetch this repo's plugins + the Neovim tarball
# build tools   : treesitter parsers + LuaSnip's jsregexp compile from source
# ripgrep/fd    : telescope live-grep / file finding
# nodejs/npm    : Mason-installed TS/JS language servers
# python venv   : Mason builds pip-based tools (e.g. ruff) in a venv
# unzip         : Mason package extraction

log "Installing system dependencies via ${PM:-<none>}..."
case "$PM" in
  apt-get) pm_install git curl tar gcc make ripgrep fd-find nodejs npm unzip python3-venv python3-pip ;;
  dnf)     pm_install git curl tar gcc make ripgrep fd-find nodejs npm unzip python3-pip ;;
  pacman)  pm_install git curl tar base-devel ripgrep fd nodejs npm unzip python-pip ;;
  zypper)  pm_install git curl tar gcc make ripgrep fd nodejs npm unzip python3-pip ;;
  apk)     pm_install git curl tar build-base ripgrep fd nodejs npm unzip python3 py3-pip ;;
  *)       warn "Skipping dependency install — make sure git, curl, a C compiler, ripgrep, fd, node, and python3 (venv+pip) are present." ;;
esac

# Debian/Ubuntu ship fd as `fdfind`; give it the name the config expects.
if command -v fdfind >/dev/null 2>&1 && ! command -v fd >/dev/null 2>&1; then
  log "Linking fdfind -> fd"
  $SUDO ln -sf "$(command -v fdfind)" "$NVIM_PREFIX/bin/fd"
fi

# --- Neovim -----------------------------------------------------------------

installed_nvim_version() {
  command -v nvim >/dev/null 2>&1 || return 1
  nvim --version | head -1 | sed 's/^NVIM v//'
}

install_neovim() {
  case "$(uname -m)" in
    x86_64)         arch="x86_64" ;;
    aarch64|arm64)  arch="arm64" ;;
    *) die "Unsupported architecture: $(uname -m)" ;;
  esac

  local tarball="nvim-linux-${arch}.tar.gz"
  local url="https://github.com/neovim/neovim/releases/download/v${NVIM_VERSION}/${tarball}"
  local tmp; tmp="$(mktemp -d)"
  trap 'rm -rf "$tmp"' RETURN

  log "Downloading Neovim ${NVIM_VERSION} (${arch})..."
  curl -fsSL "$url" -o "$tmp/$tarball" \
    || die "Failed to download $url (does v${NVIM_VERSION} ship a linux-${arch} tarball?)"

  log "Installing Neovim into ${NVIM_PREFIX}..."
  # Extract as the normal user (into our own tmp dir) so cleanup can remove it;
  # only the copy into the prefix below needs root.
  tar -C "$tmp" -xzf "$tmp/$tarball"
  # Drop stale runtime files from any previous tarball install in this prefix
  # (cp won't remove files the new version no longer ships).
  $SUDO rm -rf "$NVIM_PREFIX/share/nvim" "$NVIM_PREFIX/lib/nvim"
  $SUDO cp -rf "$tmp/nvim-linux-${arch}/." "$NVIM_PREFIX/"
}

# True if $1 (current version) is >= $2 (required version).
version_ge() {
  [ "$(printf '%s\n%s\n' "$2" "$1" | sort -V | head -1)" = "$2" ]
}

current="$(installed_nvim_version || true)"
if [ -z "$current" ]; then
  install_neovim
  log "Installed Neovim $(installed_nvim_version)."
elif version_ge "$current" "$NVIM_VERSION"; then
  log "Neovim v${current} already installed at $(command -v nvim); leaving it in place."
else
  existing="$(command -v nvim)"
  warn "Found Neovim v${current} at ${existing} (older than v${NVIM_VERSION}); upgrading."
  if [ "$existing" != "$NVIM_PREFIX/bin/nvim" ]; then
    warn "Note: existing nvim lives outside ${NVIM_PREFIX}. The new install goes to"
    warn "${NVIM_PREFIX}/bin/nvim — make sure that comes first on your PATH (it usually does)."
  fi
  install_neovim
  log "Installed Neovim $(installed_nvim_version) (was v${current})."
fi

# --- Link the config --------------------------------------------------------

mkdir -p "$(dirname "$CONFIG_DIR")"
if [ -e "$CONFIG_DIR" ] || [ -L "$CONFIG_DIR" ]; then
  if [ "$(readlink -f "$CONFIG_DIR" 2>/dev/null)" = "$SCRIPT_DIR" ]; then
    log "~/.config/nvim already points at this repo."
  else
    backup="${CONFIG_DIR}.bak.$(date +%s)"
    warn "Backing up existing $CONFIG_DIR -> $backup"
    mv "$CONFIG_DIR" "$backup"
    ln -s "$SCRIPT_DIR" "$CONFIG_DIR"
  fi
else
  log "Symlinking $CONFIG_DIR -> $SCRIPT_DIR"
  ln -s "$SCRIPT_DIR" "$CONFIG_DIR"
fi

# --- Sync plugins -----------------------------------------------------------

log "Syncing plugins (this can take a minute)..."
nvim --headless "+Lazy! sync" +qa || warn "Plugin sync hit an error; open nvim and run :Lazy to inspect."

log "Done. Launch with: nvim"
