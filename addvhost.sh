#!/bin/bash

#Author: A. Burkut

echo -n "Имя хоста: "
read newHost

echo -n "Путь к проекту: "
read newPath

#Производим запись в hosts
file="/etc/hosts"
b=$(cat $file)
newContent="127.0.0.1   ${newHost}.local"$'\n'$'\n'$b
sudo bash -c "echo '${newContent}' > $file"

#Добавляем сайт в sites-available и прописываем в него нужные директивы
sap=/etc/apache2/sites-available/$newHost.local
sudo touch $sap
sudo chmod 777 $sap

directives="
<VirtualHost *:80>
       php_admin_value display_errors On
       php_admin_value apc.enabled Off

       ServerName ${newHost}.local
       DocumentRoot ${newPath}
</VirtualHost>"

echo "$directives">$sap

#Включаем виртуальный хост
sudo a2ensite $newHost.local

#Перезапускаем сервер
sudo service apache2 restart
