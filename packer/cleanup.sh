echo "Removing kernel development tools"
apt-get -y remove linux-headers-$(uname -r) build-essential
apt-get -y autoremove

echo "Removing Project Source (will be a shared folder in Vagrant)"
rm -Rf /usr/src/elasticsearch-talk

echo "Removing Marvel Indicies"
curl -XDELETE http://localhost:9200/.marvel*

echo "Killing Reveal.js Node server"
/sbin/stop revealjs

sleep 3

exit