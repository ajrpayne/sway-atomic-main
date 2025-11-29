sudo usermod -a -G video $USER

sudo ldd /usr/lib/wsl/drivers/*/*.so | grep found

sudo dnf install intel-gmmlib
sudo ln -s /usr/lib64/libigdgmm.so.12 /usr/lib64/libigdgmm_w.so.12
sudo ls -lah /usr/lib64/libigdgmm*

sudo dnf install https://mirrors.rpmfusion.org/free/fedora/rpmfusion-free-release-$(rpm -E %fedora).noarch.rpm https://mirrors.rpmfusion.org/nonfree/fedora/rpmfusion-nonfree-release-$(rpm -E %fedora).noarch.rpm
sudo dnf config-manager setopt fedora-cisco-openh264.enabled=1

sudo dnf swap mesa-va-drivers mesa-va-drivers-freeworld
sudo dnf swap mesa-vdpau-drivers mesa-vdpau-drivers-freeworld

sudo dnf swap ffmpeg-free ffmpeg --allowerasing
sudo dnf install ffmpegthumbnailer
sudo dnf install gstreamer1-plugin-openh264 mozilla-openh264
#sudo dnf install gstreamer1-vaapi
sudo dnf install firefox

export GALLIUM_DRIVER=d3d12
export LIBVA_DRIVER_NAME=d3d12
#export LD_LIBRARY_PATH=/usr/lib/wsl/lib
sudo modprobe vgem

glxinfo -B | grep -oP '(?<=Device: )(.+)$'
glxinfo | grep Open

sudo dnf install libva-utils
vainfo --display drm --device /dev/dri/card0
vainfo --display drm --device /dev/dri/card0 -a

sudo dnf install glmark2
glmark2 -b terrain --run-forever

sudo dnf install egl-utils
eglinfo | grep version

#sudo dnf group install multimedia
#sudo dnf update @multimedia --setopt="install_weak_deps=False" --exclude=PackageKit-gstreamer-plugin
