# Setup NGINX Daemon
mkdir -p /etc/service/nginx
cat << EOF >> /etc/service/nginx/run
#!/bin/sh
exec /usr/sbin/nginx -c /etc/nginx/nginx.conf -g "daemon off;"
EOF
chmod +x /etc/service/nginx/run

# Setup MYSQL Daemon
mkdir -p /etc/service/mysql
cat << EOF >> /etc/service/mysql/run
#!/bin/sh
exec /usr/bin/mysqld_safe
EOF
chmod +x /etc/service/mysql/run

# SSH
#apt install openssh-server supervisor
# sed -E 's/^#(PermitRootLogin )no/\1yes/' /etc/ssh/sshd_config -i
#echo "PermitRootLogin yes" >> /etc/ssh/sshd_config
#ssh-keygen -A
#mkdir /run/sshd && chmod -R 700 /run/sshd
#/usr/sbin/sshd &
