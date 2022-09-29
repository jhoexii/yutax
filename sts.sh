#!/bin/bash
cp /usr/share/zoneinfo/Asia/Manila /etc/localtime


install_require()
{
  clear
  echo "Updating your system."
  {
    apt-get -o Acquire::ForceIPv4=true update
  } &>/dev/null
  clear
  echo "Installing dependencies."
  {
    apt-get -o Acquire::ForceIPv4=true install python dos2unix stunnel4 dropbear screen curl -y
  } &>/dev/null
}

install_banner()
{
clear
echo "Adding banner."
{
cat > /etc/banner << MyBanner
<br>
==========================
<br><font color=red size=7><b>WARNING</b></font>
<br>
==========================
<br>
<i><font color='green'>- NO SPAMMING !!!</br></font></i>
<br><i><font color='green'>- NO DDOS !!!</br></font></i>
<br><i><font color='green'>- NO HACKING !!!</br></font></i>
<br><i><font color='green'>- NO CARDING !!!</br></font></i>
<br><i><font color='green'>- NO TORRENT !!!</i></br></font></i>
<br>
==========================
<br>
MyBanner
    
} &>/dev/null
}

install_socks()
{
clear
echo "Installing socks."
{
wget --no-check-certificate http://firenetvpn.net/files/websocket/proxy.py -O ~/.ubuntu.py
dos2unix ~/.ubuntu.py
chmod +x ~/.ubuntu.py

cat > /etc/condom.sh << MyCondom
#!/bin/sh -e
service dropbear restart
service stunnel4 restart
screen -dmS socks python ~/.ubuntu.py
exit 0
MyCondom

chmod +x /etc/condom.sh
sudo crontab -l | { echo '@reboot bash /etc/condom.sh'; } | crontab -
} &>/dev/null
}

install_dropbear()
{
clear
echo "Installing dropbear."
{
rm -rf /etc/default/dropbear

cat > /etc/default/dropbear << MyDropbear
#FirenetDev
NO_START=0
DROPBEAR_PORT=550
DROPBEAR_EXTRA_ARGS="-p 551"
DROPBEAR_BANNER="/etc/banner"
DROPBEAR_RSAKEY="/etc/dropbear/dropbear_rsa_host_key"
DROPBEAR_DSSKEY="/etc/dropbear/dropbear_dss_host_key"
DROPBEAR_ECDSAKEY="/etc/dropbear/dropbear_ecdsa_host_key"
DROPBEAR_RECEIVE_WINDOW=65536
MyDropbear

sed -i '/\/bin\/false/d' /etc/shells
sed -i '/\/usr\/sbin\/nologin/d' /etc/shells
echo '/bin/false' >> /etc/shells
echo '/usr/sbin/nologin' >> /etc/shells

service dropbear restart
service ssh restart
} &>/dev/null
}

install_stunnel()
{
clear
echo "Installing stunnel."
{
cd /etc/stunnel/ || exit
openssl req -new -newkey rsa:2048 -days 3650 -nodes -x509 -sha256 -subj '/CN=KobzVPN/O=KobeKobz/C=PH' -keyout /etc/stunnel/stunnel.pem -out /etc/stunnel/stunnel.pem

rm -rf /etc/stunnel/stunnel.conf
echo "cert = /etc/stunnel/stunnel.pem
client = no
socket = a:SO_REUSEADDR=1
socket = l:TCP_NODELAY=1
socket = r:TCP_NODELAY=1

[stunnel]
connect = 127.0.0.1:80
accept = 443" >> stunnel.conf

cd /etc/default && rm stunnel4

echo 'ENABLED=1
FILES="/etc/stunnel/*.conf"
OPTIONS=""
PPP_RESTART=0
RLIMITS=""' >> stunnel4

chmod 755 stunnel4
sudo service stunnel4 restart
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
  echo "Server will reboot after 10 seconds"
  sleep 10

  
}

install_require
install_banner
install_dropbear
install_socks
install_stunnel
install_done
