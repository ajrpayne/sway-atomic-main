#!/bin/bash

set -ouex pipefail

### Install packages

# Packages can be installed from any enabled yum repo on the image.
# RPMfusion repos are available by default in ublue main images
# List of rpmfusion packages can be found here:
# https://mirrors.rpmfusion.org/mirrorlist?path=free/fedora/updates/39/x86_64/repoview/index.html&protocol=https&redirect=1

# https://pagure.io/workstation-ostree-config/blob/f43/f/common.yaml
dnf5 install -y \
  git-core \
  git-core-doc \
  buildah \
  podman \
  skopeo \
  slirp4netns \
  fuse-overlayfs \
  systemd-container \
  langpacks-en

# https://pagure.io/workstation-ostree-config/blob/f43/f/packages/common.yaml
dnf5 install -y \
  NetworkManager \
  NetworkManager-bluetooth \
  NetworkManager-config-connectivity-fedora \
  NetworkManager-wifi \
  NetworkManager-wwan \
  bc \
  hostname \
  mtr

# https://pagure.io/workstation-ostree-config/blob/f43/f/packages/sway-atomic.yaml
dnf5 install -y \
  NetworkManager-l2tp-gnome \
  NetworkManager-libreswan-gnome \
  NetworkManager-openconnect-gnome \
  NetworkManager-openvpn-gnome \
  NetworkManager-sstp-gnome \
  NetworkManager-vpnc-gnome \
  Thunar \
  blueman \
  bolt \
  dunst \
  foot \
  fprintd-pam \
  gnome-keyring-pam \
  gnome-themes-extra \
  grim \
  gvfs \
  gvfs-smb \
  imv \
  kanshi \
  lxqt-policykit \
  network-manager-applet \
  pavucontrol \
  pinentry-gnome3 \
  playerctl \
  plymouth-system-theme \
  polkit \
  pulseaudio-utils \
  sddm \
  sddm-wayland-sway \
  slurp \
  sway \
  sway-config-fedora \
  swaybg \
  swayidle \
  swaylock \
  system-config-printer \
  thunar-archive-plugin \
  tuned-ppd \
  tuned-switcher \
  waybar \
  wev \
  wl-clipboard \
  wlr-randr \
  wlsunset \
  xarchiver \
  xdg-desktop-portal-gtk \
  xdg-desktop-portal-wlr \
  xorg-x11-server-Xwayland

# https://github.com/ublue-os/main/blob/main/packages.json
dnf5 install -y \
  just \
  tmux \
  vim

# https://github.com/ublue-os/main/blob/9a4fca91cf190dbfeba2ff0628cf75efdff8f31c/packages.json
dnf5 install -y \
  clipman \
  gvfs-mtp \
  thunar-volman \
  tumbler

dnf5 install -y \
  NetworkManager-tui \
  bat \
  fish \
  lua5.1 \
  lua5.1-devel \
  sqlite \
  sqlite-devel \
  neovim \
  python3-pip \
  python3-neovim \
  stow \
  make \
  zig \
  ripgrep \
  go \
  gdu \
  tree-sitter-cli \
  fd-find \
  fzf \
  kubernetes-client \
  kustomize \
  helm \
  kind \
  k9s \
  yq \
  thefuck \
  distrobox \
  fastfetch \
  patch \
  seahorse \
  swappy \
  ansible \
  zoxide

wget https://luarocks.org/releases/luarocks-3.12.2.tar.gz
tar zxpf luarocks-3.12.2.tar.gz
cd luarocks-3.12.2
./configure --lua-version=5.1 --sysconfdir=/etc --prefix=/usr --rocks-tree=/usr/local && make && make install
cd ..
rm luarocks-3.12.2.tar.gz
rm -rf luarocks-3.12.2

# Use a COPR Example:
#
# dnf5 -y copr enable ublue-os/staging
# dnf5 -y install package
# Disable COPRs so they don't end up enabled on the final image:
# dnf5 -y copr disable ublue-os/staging

# Ghostty
dnf5 -y copr enable scottames/ghostty
dnf5 install -y ghostty
# Bottom
dnf5 -y copr enable atim/bottom
dnf5 install -y bottom
# Starship
dnf5 -y copr enable atim/starship
dnf5 install -y starship
# Lazygit
dnf5 -y copr enable dejan/lazygit
dnf5 install -y lazygit

#### Example for enabling a System Unit File

#systemctl enable podman.socket
