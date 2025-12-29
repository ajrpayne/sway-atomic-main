#!/bin/bash

set -ouex pipefail

### Install packages

# Packages can be installed from any enabled yum repo on the image.
# RPMfusion repos are available by default in ublue main images
# List of rpmfusion packages can be found here:
# https://mirrors.rpmfusion.org/mirrorlist?path=free/fedora/updates/39/x86_64/repoview/index.html&protocol=https&redirect=1

if [[ "${IMAGE_NAME:-undefined}" =~ ^(fsa-main|bsa-main)$ ]]; then
  dnf5 config-manager setopt fedora-cisco-openh264.enabled=0
  dnf5 config-manager setopt fedora-multimedia.enabled=1
fi
if [[ "${IMAGE_NAME:-undefined}" == "fsa-main" ]]; then
  dnf5 -y swap noopenh264 mozilla-openh264
fi
if [[ "${IMAGE_NAME:-undefined}" == "bsa-main" ]]; then
  dnf5 -y install --setopt=install_weak_deps=True \
    mozilla-openh264 \
    openh264

  dnf5 -y remove \
    xwaylandvideobridge

  # Bazzite removed
  dnf5 -y install --setopt=install_weak_deps=True \
    firefox \
    firefox-langpacks \
    toolbox
fi

# https://pagure.io/workstation-ostree-config/blob/f43/f/common.yaml
dnf5 -y install --setopt=install_weak_deps=True \
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
dnf5 -y install --setopt=install_weak_deps=True \
  NetworkManager \
  NetworkManager-bluetooth \
  NetworkManager-config-connectivity-fedora \
  NetworkManager-wifi \
  NetworkManager-wwan \
  bc \
  hostname \
  mtr

# https://pagure.io/workstation-ostree-config/blob/f43/f/packages/sway-atomic.yaml
dnf5 -y install --setopt=install_weak_deps=True --allowerasing \
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
dnf5 -y install --setopt=install_weak_deps=True \
  just \
  tmux \
  vim

# https://github.com/ublue-os/main/blob/9a4fca91cf190dbfeba2ff0628cf75efdff8f31c/packages.json
dnf5 -y install --setopt=install_weak_deps=True \
  clipman \
  gvfs-mtp \
  thunar-volman \
  tumbler

dnf5 -y install --setopt=install_weak_deps=True \
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
  k9s \
  yq \
  thefuck \
  distrobox \
  fastfetch \
  patch \
  seahorse \
  swappy \
  ansible \
  zoxide \
  rustup \
  mpv \
  celluloid \
  gammastep \
  gammastep-indicator \
  ffmpegthumbnailer \
  ffmpegthumbnailer-libs \
  htop \
  git-lfs

curl -sLO \
  'https://luarocks.org/releases/luarocks-3.12.2.tar.gz'
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
dnf5 -y install ghostty --setopt=install_weak_deps=True
dnf5 -y copr disable scottames/ghostty
# Bottom
dnf5 -y copr enable atim/bottom
dnf5 -y install bottom --setopt=install_weak_deps=True
dnf5 -y copr disable atim/bottom
# Starship
dnf5 -y copr enable atim/starship
dnf5 -y install starship --setopt=install_weak_deps=True
dnf5 -y copr disable atim/starship
# Lazygit
dnf5 -y copr enable dejan/lazygit
dnf5 -y install lazygit --setopt=install_weak_deps=True
dnf5 -y copr disable dejan/lazygit
# Homebrew
dnf5 -y copr enable ublue-os/packages
dnf5 -y install ublue-brew --setopt=install_weak_deps=True
dnf5 -y copr disable ublue-os/packages

# Cliphist
curl -sLo 'cliphist' \
  'https://github.com/sentriz/cliphist/releases/download/v0.7.0/v0.7.0-linux-amd64'
mv cliphist /usr/bin/cliphist
chmod +x /usr/bin/cliphist

if [[ "${IMAGE_NAME:-undefined}" =~ ^(fsa-main|bsa-main)$ ]]; then
  # Configs
  cp -r /ctx/etc/* /etc/

  sed -i \
    -e 's|foot|ghostty|g' \
    -e 's|default.jxl|default-dark.jxl|g' \
    /etc/sway/config
  sed -i \
    -e '/"temperature": {/a\        "interval": 60,' \
    -e 's|// "hwmon-path": "/sys/class/hwmon/hwmon2/temp1_input"|"hwmon-path": "/sys/devices/platform/coretemp.0/hwmon/hwmon5/temp1_input"|g' \
    /etc/xdg/waybar/config.jsonc

  mkdir -p /var/opt
  # Zen
  dnf5 -y copr enable sneexy/zen-browser
  dnf5 -y install zen-browser --setopt=install_weak_deps=True
  dnf5 -y copr disable sneexy/zen-browser
  mv /var/opt/zen /usr/lib/opt/zen
  echo "L /opt/zen - - - - ../../usr/lib/opt/zen" >>/usr/lib/tmpfiles.d/main-opt-fix.conf
  # Warp
  dnf5 -y install cloudflare-warp --enable-repo=cloudflare-warp --setopt=install_weak_deps=True
  mv /var/opt/cloudflare-warp /usr/lib/opt/cloudflare-warp
  echo "L /opt/cloudflare-warp - - - - ../../usr/lib/opt/cloudflare-warp" >>/usr/lib/tmpfiles.d/main-opt-fix.conf
fi

#### Example for enabling a System Unit File

systemctl enable podman.socket

echo "build.sh script complete!"
