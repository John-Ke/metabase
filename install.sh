#!/bin/bash
#######################################
# color
readonly RED="\033[1;31m"
readonly GREEN="\033[1;32m"
readonly WHITE="\033[1;37m"
readonly YELLOW="\033[1;33m"
readonly GRAY_LIGHT="\033[0;37m"
readonly CYAN_LIGHT="\033[1;36m"
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
  sleep 2

  printf "\n"
  printf "\n"
  }
print_banner
# Verifica se o usuário é root
if [ "$(id -u)" -ne 0 ]; then
    echo "Este script precisa ser executado como root. Executando sudo su..."
    sudo su
    sleep 2
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

system_date 
system_date () {
  print_banner
  printf "${WHITE} 💻 Ajustando horario do Servidor...${GRAY_LIGHT}"
  printf "\n\n"

  sleep 2

  sudo su - root <<EOF
  sudo timedatectl set-timezone America/Belem
EOF

  sleep 2
}
system_date  

system_update 
system_update() {
  print_banner
  printf "${WHITE} 💻 Vamos atualizar o sistema...${GRAY_LIGHT}"
  printf "\n\n"

  sleep 2

  sudo su - root <<EOF
  apt -y update && apt -y upgrade
EOF

  sleep 2
}
system_update 

system_dependencies
system_dependencies() {
  print_banner
  printf "${WHITE} 💻 Instalando dependencias...${GRAY_LIGHT}"
  printf "\n\n"

  sleep 2

  sudo su - root <<EOF
  sudo apt-get install apt-utils -y && sudo apt-get install net-tools -y
EOF

  sleep 2
}
system_dependencies

system_java
system_java() {
  print_banner
  printf "${WHITE} 💻 Instalando Java JDK...${GRAY_LIGHT}"
  printf "\n\n"

  sleep 2

  sudo su - root <<EOF
  sudo apt install openjdk-11-jdk openjdk-11-jre

EOF

  sleep 2
}
system_java

system_db
system_db() {
  print_banner
  printf "${WHITE} 💻 Instalando Banco de Dados...${GRAY_LIGHT}"
  printf "\n\n"

  sleep 2

  sudo su - root <<EOF
  sudo apt-get install mysql-server mysql-client -y
EOF
  sleep 2
}
system_db

#system_db_conf
#system_db_conf() {
#  print_banner
#  printf "${WHITE} 💻 Configurando Banco de Dados...${GRAY_LIGHT}"
#  printf "\n\n"
#
#  sleep 2
#
#  sudo su - root <<EOF
#  sudo mysql -u root -pa8e3dd84
#  CREATE DATABASE metabase;
#  CREATE USER 'metabase_user'@'localhost' IDENTIFIED BY 'Mj@45900';
#  GRANT ALL ON metabase.* TO 'metabase_user'@'localhost' WITH GRANT OPTION;
#  FLUSH PRIVILEGES;
#  EXIT;
#EOF
#
#  sleep 2
#}
#system_db_conf

metabase_download
metabase_download() {
  print_banner
  printf "${WHITE} 💻 Donwload do Metabase...${GRAY_LIGHT}"
  printf "\n\n"

  sleep 2

  sudo su - root <<EOF
  sudo mkdir /home/metabase
  cd /home/metabase
#  sudo wget https://downloads.metabase.com/v0.49.10/metabase.jar
  
EOF
  sleep 2
}
metabase_download

metabase_config
metabase_config() {
  print_banner
  printf "${WHITE} 💻 Ajustando o ambiente para o Metabase...${GRAY_LIGHT}"
  printf "\n\n"

  sleep 2

  sudo su - root <<EOF
  cd /home/metabase
  sudo groupadd -r metabase
  sudo useradd -r -s /bin/false -g metabase metabase
  sudo chown -R metabase:metabase /home/metabase
  sudo touch /var/log/metabase.log
  sudo chown metabase:metabase /var/log/metabase.log
  sudo touch /etc/default/metabase
  sudo chmod 775 /etc/default/metabase
  
EOF
  sleep 2
}
metabase_config

metabase_config_log
metabase_config_log() {
  print_banner
  printf "${WHITE} 💻 Ajustando logs do Metabase...${GRAY_LIGHT}"
  printf "\n\n"

  sleep 2

  sudo su - root <<EOF
  cd /etc/rsyslog.d/
  cat > metabase.conf << 'END'
  if $programname == 'metabase' then /var/log/metabase.log
  & stop
END
    sudo chmod 775 /var/log/metabase.log
    sudo systemctl restart rsyslog.service
EOF
  sleep 2
}
metabase_config_log

metabase_config_db
metabase_config_db() {
  print_banner
  printf "${WHITE} 💻 Conectado ao banco de dados do Metabase...${GRAY_LIGHT}"
  printf "\n\n"

  sleep 2

  sudo su - root <<EOF
  cd /etc/default/
  cat > metabase << 'END'
MB_PASSWORD_COMPLEXITY=strong
MB_PASSWORD_LENGTH=10
MB_DB_TYPE=mysql
MB_DB_DBNAME=metabase
MB_DB_PORT=3306
MB_DB_USER=metabase_user
MB_DB_PASS=Mj@45900
MB_DB_HOST=localhost
MB_EMOJI_IN_LOGS=true
MB_JETTY_PORT=3000
END
    sudo chmod 775 /var/log/metabase.log
    sudo systemctl restart rsyslog.service
EOF
  sleep 2
}
metabase_config_db

metabase_config_servico
metabase_config_servico() {
  print_banner
  printf "${WHITE} 💻 Criando servico  do Metabase...${GRAY_LIGHT}"
  printf "\n\n"

  sleep 2

  sudo su - root <<EOF
  cd /etc/systemd/system/
  cat > metabase.service << 'END'
[Unit]
Description=Metabase server
After=syslog.target
After=network.target
[Service]
WorkingDirectory=/home/metabase/
ExecStart=/usr/bin/java -jar /home/metabase/metabase.jar
EnvironmentFile=/etc/default/metabase
User=metabase
Type=simple
StandardOutput=syslog
StandardError=syslog
SyslogIdentifier=metabase
SuccessExitStatus=143
TimeoutStopSec=120
Restart=always
[Install]
WantedBy=multi-user.target

END

EOF
  sleep 2
}
metabase_config_servico


metabase_ativacao
metabase_ativacao() {
  print_banner
  printf "${WHITE} 💻 Ativando o Metabase...${GRAY_LIGHT}"
  printf "\n\n"

  sleep 2

  sudo su - root <<EOF
    sudo systemctl daemon-reload
    sudo systemctl enable metabase
    sudo systemctl restart metabase
EOF
  sleep 2
}
metabase_ativacao

## bash <(curl -sSL setup.bytehost.com.br)
