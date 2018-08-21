#!/bin/sh
# Update the pihole list with youtube ads 
# this shell is made by Kiro 
#Thank you for using it and enjoy 

# The script will create a file with all the youtube ads found in hostsearch and from the logs of the Pi-hole
# it will append the list into a file called blacklist.txt'/etc/pihole/blacklist.txt'

piholeIPV4=`hostname -I |awk '{print $1}'`

balckListFile='/etc/pihole/black.list'
blacklist='/etc/pihole/blacklist.txt'

# Get the domain list from hackeragent api 
# change it to be r[Number]---sn--
# added to the youtubeFile
sudo curl 'https://api.hackertarget.com/hostsearch/?q=googlevideo.com' \
| awk -F, 'NR>1{print $1}'|sed "s/\(^r[[:digit:]]*\)\.\(sn\)/$piholeIPV4 \1---\2-/ ">>$balckListFile

sudo curl 'https://api.hackertarget.com/hostsearch/?q=googlevideo.com' \
| awk -F, 'NR>1{print $1}'|sed "s/\(^r[[:digit:]]*\)\.\(sn\)/\1---\2-/ ">>$blacklist

#testing
read -n 1 -s

# collecting the youtube ads website from the pihole logs and added it the youtubeList.txt 
sudo cat /var/log/pihole*.log |grep 'r[0-9]*-.*.googlevideo'|awk -v a=$piholeIPV4 '{print a " " $8}'|sort |uniq>> $balckListFile
sudo cat /var/log/pihole*.log |grep 'r[0-9]*-.*.googlevideo'|awk '{print $8}'|sort |uniq>> $blacklist
#testing
read -n 1 -s

wait 
# remove the duplicate records in place
awk -i inplace '!a[$0]++' $balckListFile
wait 
awk -i inplace '!a[$0]++' $blacklist
