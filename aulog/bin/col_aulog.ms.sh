#!/bin/bash
dat=`date +%m/%d/%y`
dat1=`date +%m%d%y`
export dat1
dat2=`date +%y%m%d`
log_dat=`date +%Y%m%d`
export log_dat
mkdir /aulog/audreport/$dat1
##### file name #####
loginout=/aulog/audreport/$dat1/medi2T_login_out.txt
aufile=/aulog/audreport/$dat1/medi2T_file.txt
sutxt=/aulog/audreport/$dat1/medi2T_sulog.txt
pwdchg=/aulog/audreport/$dat1/medi2T_password.txt


#### Login out #########
last > $loginout
#cp /var/log/wtmp /var/log/wtmp.$dat
echo " " > /var/log/wtmp

#### config and import file ######
aureport -f -ts $dat -te $dat > /aulog/audreport/$dat1/medi2T_file.txt


##### su and sudo file ######
cp /var/log/sulog $sutxt
echo " " > /var/log/sulog

###### password file ########
cp /var/log/messages $pwdchg
echo " " > /var/log/messages

service rsyslog restart

mv /aulog/audreport/$dat1/medi2T_login_out.txt /aulog/audreport/$dat1/medi2T_login_out_$dat2.txt
mv /aulog/audreport/$dat1/medi2T_file.txt /aulog/audreport/$dat1/medi2T_file_$dat2.txt
mv /aulog/audreport/$dat1/medi2T_sulog.txt /aulog/audreport/$dat1/medi2T_sulog_$dat2.txt
mv /aulog/audreport/$dat1/medi2T_password.txt /aulog/audreport/$dat1/medi2T_password_$dat2.txt
tar -cvf /aulog/audreport/$dat1/medi2T_OSLog_$dat2 /aulog/audreport/$dat1/*


###### FTP to LOG Server #########
cd /aulog/audreport/$dat1
# ftp -in < /aulog/bin/ftp_log_conf


##### delete audit log ########
/etc/init.d/auditd stop
find /aulog/audit.log* -mtime +95 -exec rm {} \;
find /aulog/audreport -mtime +95 -exec rm -rf {} \;
/etc/init.d/auditd start


##### FTP OS Files #######
cd /aulog/audreport/$dat1
# ftp -in < /aulog/bin/ftpaudit1

cd /aulog/audreport/$dat1
# ftp -in < /aulog/bin/ftpaudit2

cd /aulog/audreport/$dat1
# ftp -in < /aulog/bin/ftpaudit3

cd /aulog/audreport/$dat1
# ftp -in < /aulog/bin/ftpaudit4


#### Delete mail log #####
#/aulog/bin/del_maillog.sh


