#!/bin/bash
#
# Print banner art.

#######################################
# Print a board. 
# Globals:
#   BG_BROWN
#   NC
#   WHITE
#   CYAN_LIGHT
#   RED
#   GREEN
#   YELLOW
# Arguments:
#   None
#######################################
print_banner() {

  clear

  printf "\n\n"

  printf "${GREEN}";
printf "'########::'##:::'##:'########:'########:\n";
printf " ##.... ##:. ##:'##::... ##..:: ##.....::\n";
printf " ##:::: ##::. ####:::::: ##:::: ##:::::::\n";
printf " ########::::. ##::::::: ##:::: ######:::\n";
printf " ##.... ##:::: ##::::::: ##:::: ##...::::\n";
printf " ##:::: ##:::: ##::::::: ##:::: ##:::::::\n";
printf " ########::::: ##::::::: ##:::: ########:\n";
printf ".........::::::..::::::::..:::::........:\n";
  printf "\n";
  printf "ESSE MATERIAL FAZ PARTE DA BYTEHOST\n";
  printf "\n";
  printf "Compartilhar, vender ou fornecer essa solução\n";
  printf "sem autorização é crime previsto no artigo 184\n";
  printf "do código penal que descreve a conduta criminosa\n";
  printf "de infringir os direitos autorais da BYTEHOST.\n";
  printf "\n";
  printf "PIRATEAR ESSA SOLUÇÃO É CRIME.\n";
  printf "\n";
  printf " © Bytehost.com.br\n";
  printf "${NC}";

  printf "\n"
}

# Verifica se o usuário é root
if [ "$(id -u)" -ne 0 ]; then
    echo "Este script precisa ser executado como root. Executando sudo su..."
    sudo su
fi

# Verifica se o usuário está no diretório /root/
if [ "$PWD" != "/root" ]; then
    echo "Mudando para o diretório /root/"
    cd /root || exit
fi

# Verifica se está usando Ubuntu 20.04
if ! grep -q 'Ubuntu 20.04' /etc/os-release; then
    echo "Este script recomenda o uso do Ubuntu 20.04."
    sleep 3
fi

# update and install dependencies required by metabase
sudo apt-get install -y apt-utils

sudo apt update

sudo apt upgrade -y

# install java
sudo apt install openjdk-11-jdk openjdk-11-jre
