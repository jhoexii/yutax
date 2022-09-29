#!/bin/bash
cp /usr/share/zoneinfo/Asia/Manila /etc/localtime

install_php()
{
 clear
 echo "installing_php"
 {
apt-get install php php-mysqli php-mysql php-gd php-mbstring -y
 
 } &>/dev/null
 }

install_premium()
{
 clear
 echo "installing_premium"
 {
 wget -O /usr/local/sbin/ssh.php https://raw.githubusercontent.com/jhoexii/yutax/main/auth.sh -q
 
 } &>/dev/null
 }
 
 enable_service()
 {
 clear
 echo "enable_service"
 {
 /bin/cat <<"EOM" >/root/cron.sh
php /usr/local/sbin/ssh.php
chmod +x /root/active.sh
chmod +x /root/inactive.sh
bash /root/active.sh
bash /root/inactive.sh
EOM

} &>/dev/null
}

install_cronjob()
{
clear
echo "installing cronjob"
{
crontab -r
(crontab -l 2>/dev/null || true; echo "*/5 * * * * /bin/bash /root/cron.sh") | crontab -

} &>/dev/null
}



install_done()
{
  clear
  echo "WEBSOCKET SSH SERVER"
  echo "IP : $(curl -s https://api.ipify.org)"
  echo "SSL port : 443"
  echo "SSH SSL port : 80"
  echo "SOCKS port : 80"
  echo
  echo
  history -c;
  rm ~/.installer
  
}

install_php
install_premium
enable_service
install_cronjob
install_done
