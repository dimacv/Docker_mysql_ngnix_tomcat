#!/bin/bash
# СТАРТ SSH :
/usr/sbin/sshd &

# Запуск mysql в фоне
sudo /usr/bin/mysqld_safe --defaults-file=/etc/mysql/mysql.conf.d/mysqld.cnf > /dev/null 2>&1 &
sleep 20

/opt/tomcat/bin/startup.sh run

