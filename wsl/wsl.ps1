wsl --shutdown
wsl --unregister FedoraLinux-43
wsl --install FedoraLinux-43 -n
wsl -d FedoraLinux-43 build_files/build.sh
wsl --shutdown
wsl -d FedoraLinux-43
wsl -d FedoraLinux-43 scripts/.dotfiles.sh
wsl -d FedoraLinux-43
