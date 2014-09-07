echo "Removing logs from initialization."
rm -f /var/log/*.log /var/log/*.gz /var/log/dmesg*
rm -fr /var/log/syslog /var/log/upstart/*.log /var/log/{b,w}tmp /var/log/udev

echo "Getting rid of bash history."
rm -f $HOME/.bash_history

echo "Removing any Linux kernel packages that we aren't using to boot."
dpkg -l 'linux-*' | sed '/^ii/!d;/'"$(uname -r | sed "s/\(.*\)-\([^0-9]\+\)/\1/")"'/d;s/^[^ ]* [^ ]* \([^ ]*\).*/\1/;/[0-9]/!d' | xargs sudo apt-get -y purge

echo "Cleaning out any cached interfaces."
rm -f /etc/udev/rules.d/70-persistent-net.rules

echo "Cleaning out apt cache, lists, and autoremoving any packages."
rm -f /var/lib/apt/lists/lock
rm -f /var/lib/apt/lists/*_*
rm -f /var/lib/apt/lists/partial/*
# apt-get -y autoremove
apt-get -y clean

echo "Removing Project Source (will be a shared folder in Vagrant)"
rm -Rf /usr/src/elasticsearch-talk

echo "Removing Marvel Indicies"
curl -XDELETE http://localhost:9200/.marvel*

echo "Killing Reveal.js Node server"
/sbin/stop revealjs

sleep 3

exit