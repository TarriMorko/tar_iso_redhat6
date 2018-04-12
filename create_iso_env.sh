#!/bin/bash
#
#

if ! [ -f /etc/redhat-release ]; then
    echo "This script is for redhat ONLY."
    exit 0
fi

export LANG=POSIX
export LC_ALL=POSIX

cp -p /etc/issue /etc/issue.bak
cp -p /etc/issue.net  /etc/issue.net.bak
cp -p /etc/login.defs  /etc/login.defs.bak
cp -p /etc/pam.d/sshd /etc/pam.d/sshd.bak
cp -p /etc/pam.d/system-auth-ac /etc/pam.d/system-auth-ac.bak
authconfig --savebackup=./authconfig_backup

cp -p /etc/audit/audit.rules /etc/audit/audit.rules.bak
cp -p /etc/audit/auditd.conf /etc/audit/auditd.conf.bak
cp -p /etc/profile.local /etc/profile.local.bak
cp -p /etc/profile /etc/profile.bak
cp -p /etc/cron.allow /etc/cron.allow.bak
cp -p /etc/services /etc/services.bak
cp -p /etc/pam.d/system-auth /etc/pam.d/system-auth.bak
cp -p /etc/rsyslog.conf /etc/rsyslog.conf.bak


#############

sed s/bash/nologin/g /etc/passwd | grep -v root  > /etc/passwd.tmp
cat /etc/passwd | grep root >> /etc/passwd.tmp
cat /etc/passwd.tmp > /etc/passwd
rm /etc/passwd.tmp
##############
tar -xvpPf /tmp/tar_iso_redhat6.tar

# /etc/rc.d/sshd  restart
service sshd restart
# /etc/rc.d/syslog restart
/etc/init.d/rsyslog restart

chkconfig autofs off
chkconfig blk-availability off
chkconfig cpuspeed off
chkconfig haldaemon off
chkconfig ip6tables off
chkconfig lvm2-monitor off
chkconfig mdmonitor off
chkconfig netfs off
chkconfig cups off
chkconfig portreserve off
chkconfig bluetooth off
chkconfig httpd off

mkdir -p /aulog/audreport
chmod -R 700 /aulog/audreport
chmod -R 700 /root

# use sha512 instead of md5 for password
authconfig --passalgo=sha512 --update

## Add Accounts
groupadd -g 800 datactrl
groupadd -g 900 dc1
groupadd -g 920 dc3
groupadd -g 700 sp

useradd opusr -c opusr -g 800 -m -u 802 -s /bin/bash
useradd spadmin -c spadmin -g 700 -m -u 712 -s /bin/bash
useradd spos1 -c spos1 -g 700 -m -u 701 -s /bin/bash
useradd spos2 -c spos2 -g 700 -m -u 702 -s /bin/bash
useradd spos3 -c spos3 -g 700 -m -u 703 -s /bin/bash
useradd spos4 -c spos4 -g 700 -m -u 704 -s /bin/bash

# faillog -m 5 -u spos1
# faillog -m 5 -u spos2
# faillog -m 5 -u spos3
# faillog -m 5 -u dc01
# faillog -m 5 -u dcporting
# faillog -m 5 -u spadmin

