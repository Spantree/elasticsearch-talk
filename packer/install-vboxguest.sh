# This script installs DKMS and ACPI support (so power button registers),
# and then follows up with VirtualBox guest extension installation & cleanup.

echo "Installing VirtualBox guest additions"

sudo mount -t iso9660 -o ro -o loop "$HOME/VBoxGuestAdditions.iso" /media/cdrom
# If there's no X11, then this will have exit code 1.
sudo sh /media/cdrom/VBoxLinuxAdditions.run || true
sudo umount /media/cdrom
sudo rm -f $HOME/VBoxGuestAdditions.iso
if [ -d /opt/VBoxGuestAdditions-4.3.10 ]; then
  # Temporary work-around until this VirtualBox bug is fixed in 4.3.10:
  #  https://www.virtualbox.org/ticket/12879
  sudo ln -s /opt/VBoxGuestAdditions-4.3.10/lib/VBoxGuestAdditions /usr/lib/VBoxGuestAdditions
fi