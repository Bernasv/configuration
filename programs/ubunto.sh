#!/usr/bin/env bash

PPA_GRAPHICS_DRIVERS="ppa:graphics-drivers/ppa"
PPA_GOLANG="ppa:longsleep/golang-backports"
URL_GOOGLE_CHROME="https://dl.google.com/linux/direct/google-chrome-stable_current_amd64.deb"
URL_DISCORD="https://discordapp.com/api/download?platform=linux&format=deb"
URL_DROPBOX="https://www.dropbox.com/download?dl=packages/ubuntu/dropbox_2019.02.14_amd64.deb"
URL_BURP="https://portswigger.net/burp/releases/download?product=community&version=2.1.07&type=linux&componentid=100"
URL_BOOSTNOTE="https://github.com/BoostIO/BoostNote.next/releases/latest/download/boost-note-linux.deb"
URL_VAGRANT="https://releases.hashicorp.com/vagrant/2.2.6/vagrant_2.2.6_x86_64.deb"
DOWNLOAD_FOLDER="$HOME/Downloads/programs"

PROGRAMS_TO_INSTALL=(
  curl
  wireshark
  ardour
  snapd
  flatpak
  gnome-software-plugin-flatpak
  build-essential
  git
  docker
  docker-compose
  libssl-dev
  keepassxc
  python3
  python3-pip
  python3-setuptools
  python3-pyqt5
  python3-opencv
  vim
  tmux
  lmms
  htop
  gnome-tweaks
  apt-transport-https
  clang
  gdb
  python
  python-pip
  python-dev
  libffi-dev
  ruby-full
  openjdk-8-jdk
  openjdk-11-jdk
  golang-go
  virtualbox-qt
)

sudo rm /var/lib/dpkg/lock-frontend
sudo rm /var/cache/apt/archives/lock
sudo rm /var/lib/apt/lists/lock

sudo dpkg --add-architecture i386

sudo apt update -y
sudo apt list --upgradable

## Add Repositories ##
sudo apt-add-repository "$PPA_GRAPHICS_DRIVERS" -y
sudo apt-add-repository "$PPA_GOLANG" -y

sudo apt update -y
sudo apt list --upgradable

## Install apt programs ##
for program_name in ${PROGRAMS_TO_INSTALL[@]}; do
    sudo apt install "$program_name" -y
done

## Download external programs ##
mkdir "$DOWNLOAD_FOLDER"
wget -c "$URL_GOOGLE_CHROME"  -O "$DOWNLOAD_FOLDER/chrome.deb"
wget -c "$URL_DISCORD"        -O "$DOWNLOAD_FOLDER/discord.deb"
wget -c "$URL_DROPBOX"        -O "$DOWNLOAD_FOLDER/dropbox.deb"
wget -c "$URL_BURP"           -O "$DOWNLOAD_FOLDER/burp.sh"
wget -c "$URL_BOOSTNOTE"      -O "$DOWNLOAD_FOLDER/boostnote.deb" 
wget -c "$URL_VAGRANT"        -O "$DOWNLOAD_FOLDER/vagrant.deb" 


## Install downloaded debs ##
sudo dpkg -i $DOWNLOAD_FOLDER/*.deb

## Configure gdb ##
wget -O ~/.gdbinit-gef.py -q https://github.com/hugsy/gef/raw/master/gef.py
echo source ~/.gdbinit-gef.py >> ~/.gdbinit

## Install Flatpacks ##
sudo flatpak install https://flathub.org/repo/appstream/org.gimp.GIMP.flatpakref -y
sudo flatpak install flathub com.obsproject.Studio -y

## Configure Homestead for laravel ##
git clone https://github.com/laravel/homestead.git ~/Homestead
cd ~/Homestead
git checkout release
bash init.sh

## Install Snaps ##
sudo snap install code --classic
sudo snap install spotify
sudo snap install odrive-unofficial
sudo snap install slack --classic
sudo snap install --classic code
sudo snap install postman
sudo snap install intellij-idea-ultimate --classic
sudo snap install skype --classic
sudo snap install gravit-designer
sudo snap install electrum
sudo snap install pypy --classic

##Install VsCode Extensions
code --install-extension dbaeumer.vscode-eslint
code --install-extension ms-python.python
code --install-extension ms-vscode.cpptools
code --install-extension PKief.material-icon-theme
code --install-extension ritwickdey.LiveServer
code --install-extension SolarLiner.linux-themes

##Install Python Packages
sudo pip3 install pwntools
sudo pip3 install Django
sudo pip3 install Flask
sudo pip3 install jupyterlab
sudo pip3 install tensorflow
sudo pip3 install torch torchvision
sudo pip3 install keras
sudo pip3 install numpy
sudo pip3 install pandas
sudo pip3 install matplotlib
sudo pip3 install astropy
sudo pip3 install scipy
sudo pip3 install unicorn
sudo pip3 install opencv-python
sudo pip3 install PyOpenGL PyOpenGL_accelerate
sudo pip3 install pygame

#configure nvm
wget -c "https://raw.githubusercontent.com/creationix/nvm/v0.30.2/install.sh"  -O "$DOWNLOAD_FOLDER/nvm.sh"
bash "$DOWNLOAD_FOLDER/nvm.sh"
source ~/.bashrc
source ~/.profile
nvm install node

## Post Installation ##
sudo apt list --upgradable
sudo apt update && sudo apt dist-upgrade -y
sudo apt --fix-broken install -y
sudo flatpak update -y
sudo apt autoclean -y
sudo apt autoremove -y
sudo apt upgrade -y
##Configure vagrant to work with virtual box
sudo dpkg-reconfigure virtualbox-dkms
sudo modprobe vboxdrv
sudo rm -rf $DOWNLOAD_FOLDER/*.deb

