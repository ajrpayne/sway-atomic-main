notepad "$env:USERPROFILE\.wslconfig"
[wsl2]
memory=16GB
processors=8

```powershell
wsl --export FedoraLinux-44 --format vhd f44dev.vhdx
wsl --import-in-place f44dev "$FOLDER\f44dev.vhdx"
wsl --manage f44dev --set-default-user "$USER"
wsl -d f44dev
```

```powershell
cd C:\
git clone https://github.com/ajrpayne/sway-atomic-main
cd .\sway-atomic-main\
wsl --shutdown
wsl --unregister FedoraLinux-44
wsl --install FedoraLinux-44 -n --location "$FOLDER"
.\wsl\wsl.ps1
sudo passwd "$USER"
brew bundle install --file ~/Brewfile --verbose
#brew cleanup --prune=all
nvim
```
