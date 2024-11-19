#!/bin/bash

# os_installed='' # TODO: Customization

# PS3='Distro installed: '
# options=("Zorin OS" "Pop OS! Cosmic")
# select opt in "${options[@]}"; do
#   case $opt in
#   "Zorin OS")
#     os_installed='zorin' #TODO
#     break
#     ;;
#   "Pop OS! Cosmic")
#     os_installed='pop' #TODO
#     break
#     ;;
#   *) echo "invalid option $REPLY" ;;
#   esac
# done

clear

PS3='Is ç (cedilla) working as expected?: '
options=("Yes" "No")
select opt in "${options[@]}"; do
  case $opt in "Yes")
    break
    ;;
  "No")
    echo GTK_IM_MODULE=cedilla | sudo tee -a /etc/environment
    # https://askubuntu.com/questions/1399244/cedilla-no-longer-working-with-us-intl-keyboard-layout
    break
    ;;
  *)
    echo "invalid option $REPLY"
    ;;
  esac
done

clear

# UPDATE & UPGRADE
sudo apt update
sudo apt upgrade

# Fix Windows wrong time display
timedatectl set-local-rtc 1 --adjust-system-clock

# Install Git
dpkg -s git &>/dev/null
if [ $? -eq 1 ]; then
  sudo apt install git
fi

clear

dpkg -s flatpak &>/dev/null

if [ $? -eq 1 ]; then
  PS3='Flatpak is not installed. Install it?: '
  options=("Yes" "No")
  select opt in "${options[@]}"; do
    case $opt in "Yes")
      echo 'flatpak is not installed'
      sudo add-apt-repository ppa:flatpak/stable
      sudo apt update
      sudo apt install flatpak
      sudo apt install gnome-software-plugin-flatpak
      break
      ;;
    "No")
      break
      ;;
    *)
      echo "invalid option $REPLY"
      ;;
    esac
  done
fi

# Install Charles Proxy
dpkg -s charles-proxy &>/dev/null
if [ $? -eq 1 ]; then
  wget -qO- https://www.charlesproxy.com/packages/apt/charles-repo.asc | sudo tee /etc/apt/keyrings/charles-repo.asc
  sudo sh -c 'echo deb [signed-by=/etc/apt/keyrings/charles-repo.asc] https://www.charlesproxy.com/packages/apt/ charles-proxy main > /etc/apt/sources.list.d/charles.list'
  sudo apt update && sudo apt install charles-proxy
fi
