echo "Disabling UseDNS in `sshd_config`."
sed /UseDNS/d /etc/ssh/sshd_config > /tmp/sshd_config
echo "UseDNS no" >> /tmp/sshd_config
sudo mv /tmp/sshd_config /etc/ssh/sshd_config
if [ `uname -s` = 'Linux' ]; then
    sudo chown root:root /etc/ssh/sshd_config
else
    sudo chown root:wheel /etc/ssh/sshd_config
fi

echo "Adding Vagrant's insecure private key to authorized keys."
mkdir -m 0700 -p $HOME/.ssh
echo "ssh-rsa AAAAB3NzaC1yc2EAAAABIwAAAQEA6NF8iallvQVp22WDkTkyrtvp9eWW6A8YVr+kz4TjGYe7gHzIw+niNltGEFHzD8+v1I2YJ6oXevct1YeS0o9HZyN1Q9qgCgzUFtdOKLv6IedplqoPkcmF0aYet2PkEDo3MlTBckFXPITAMzF8dJSIFo9D8HfdOV0IAdx4O7PtixWKn5y2hMNG0zQPyUecp4pzC6kivAIhyfHilFR61RGL+GPXQ2MWZWFYbAGjyiYJnAmCP3NOTd0jMZEnDkbUvxhMmBYSdETk1rRgm+R4LOzFUGaHqHDLKLX+FIPKcF96hrucXzcWyLbIbEgE98OHlnVYCzRdK8jlqm8tehUc9c9WhQ== vagrant insecure public key" >> $HOME/.ssh/authorized_keys
chmod 0600 $HOME/.ssh/authorized_keys