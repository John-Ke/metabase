#------------------------------------------------
#  MIGRACAO AUTOMATIZADA DO BANCO H2 PARA MYSQL 
#        DO METABASE NO ORACLE LINUX 8
#------------------------------------------------

#-------------------------------------------------
#
echo "#--------------------------------------------------------#"
echo             "PARANDO SERVICO DO METABASE"
echo "#--------------------------------------------------------#"
systemctl stop metabase
clear
echo "#--------------------------------------------------------#"
echo             "INFORMACOES DO BANCO MYSQL"
echo "#--------------------------------------------------------#"
read -p    "Digite o IP do Servidor de banco: " dbipserver
read -p              "Digite o nome do banco: " dbname
read -p           "Digite o usuario do banco: " dbuser
read -p             "Digite a senha do banco: " dbpasswd
clear
echo "#--------------------------------------------------------#"
echo      "CRIANDO SCRIPT DE INICIALIZACAO"
echo "#--------------------------------------------------------#"
touch /usr/share/metabase/start-metabase-mysql.sh
cat <<EOF | sudo tee /usr/share/metabase/start-metabase-mysql.sh
#!/bin/bash
MB_ENCRYPTION_SECRET_KEY=gftfkCjdIqo4bugIBGlMsdfsd$dbpasswd= MB_DB_CONNECTION_URI="mysql://$dbipserver:3306/$dbname?user=$dbuser&password=$dbpasswd" java -jar /usr/share/metabase/metabase.jar
EOF
chmod +x /usr/share/metabase/start-metabase-mysql.sh
echo "#--------------------------------------------------------#"
echo              "RECRIANDO ARQUIVO DE SERVICO"
echo "#--------------------------------------------------------#"
systemctl daemon-reload
systemctl enable metabase
echo "#-----------------------------------------#"
echo        "MIGRAR DE H2 PARA MYSQL"
echo "#-----------------------------------------#"
cd /opt/metabase
export MB_DB_TYPE=mysql
export MB_DB_DBNAME=$dbname
export MB_DB_PORT=3306
export MB_DB_USER=$dbuser
export MB_DB_PASS=$dbpasswd
export MB_DB_HOST=$dbipserver
java -jar metabase.jar load-from-h2 /opt/metabase/metabase.db
echo "#--------------------------------------------------------#"
echo             "MOVENDO ARQUIVOS DO BANCO H2"
echo "#--------------------------------------------------------#"
mv /opt/metabase/*.db /tmp
echo "#--------------------------------------------------------#"
echo            "INICIANDO METABASE COM MYSQL"
echo "#--------------------------------------------------------#"
systemctl restart metabase
tail -f /var/log/metabase.log
echo FIM

#------------------------------
# OPÇÃO 2 CASO DER ERRO NA DE CIMA
# java -DMB_DB_TYPE=mysql -DMB_DB_CONNECTION_URI="jdbc:mysql://localhost:3306/metabase?user=metabase&password=SUA-SENHA-ALTERAR&useSSL=false&allowPublicKeyRetrieval=true" -jar metabase.jar load-from-h2 metabase.db
