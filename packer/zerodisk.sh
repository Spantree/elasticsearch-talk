echo "Performing one last sitewide upgrade"
apt-get update 
apt-get -y dist-upgrade

echo "Cleaning home directory for vagrant user"
cd $HOME
rm -rf *.*

echo "Zeroing the free space to save space in the final image"
dd if=/dev/zero of=/EMPTY bs=1M
rm -f /EMPTY
