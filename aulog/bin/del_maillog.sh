#!/bin/sh
outfila=/tmp/del_maillog.txt
ls -l /var/spool/mail |awk '{print $9}' > $outfila
for i in `cat $outfila`
 do
 cat /dev/null > /var/spool/mail/$i
 done
rm $outfila
