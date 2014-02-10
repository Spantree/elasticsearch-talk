#!/bin/bash

PWD=/usr/src/elasticsearch-talk/shell
OS=$(/bin/bash $PWD/os-detect.sh ID)
RELEASE=$(/bin/bash $PWD/os-detect.sh RELEASE)
CODENAME=$(/bin/bash $PWD/os-detect.sh CODENAME)

if [[ ! -f /var/puppet-init/update-puppet ]]; then
    if [ "$OS" == 'debian' ] || [ "$OS" == 'ubuntu' ]; then
        echo "Downloading http://apt.puppetlabs.com/puppetlabs-release-${CODENAME}.deb"
        wget --quiet --tries=5 --timeout=10 -O "/var/puppet-init/puppetlabs-release-${CODENAME}.deb" "http://apt.puppetlabs.com/puppetlabs-release-${CODENAME}.deb"
        echo "Finished downloading http://apt.puppetlabs.com/puppetlabs-release-${CODENAME}.deb"

        dpkg -i "/var/puppet-init/puppetlabs-release-${CODENAME}.deb" >/dev/null

        echo "Running update-puppet apt-get update"
        apt-get update >/dev/null
        echo "Finished running update-puppet apt-get update"

        echo "Updating Puppet to latest version"
        apt-get -y install puppet >/dev/null
        PUPPET_VERSION=$(puppet help | grep 'Puppet v')
        echo "Finished updating puppet to latest version: $PUPPET_VERSION"

        touch /var/puppet-init/update-puppet
        echo "Created empty file /var/puppet-init/update-puppet"
    elif [ "$OS" == 'centos' ]; then
        echo "Downloading http://yum.puppetlabs.com/el/${RELEASE}/products/x86_64/puppetlabs-release-6-7.noarch.rpm"
        yum -y --nogpgcheck install "http://yum.puppetlabs.com/el/${RELEASE}/products/x86_64/puppetlabs-release-6-7.noarch.rpm" >/dev/null
        echo "Finished downloading http://yum.puppetlabs.com/el/${RELEASE}/products/x86_64/puppetlabs-release-6-7.noarch.rpm"

        echo "Running update-puppet yum update"
        yum -y update >/dev/null
        echo "Finished running update-puppet yum update"

        echo "Installing/Updating Puppet to latest version"
        yum -y install puppet >/dev/null
        PUPPET_VERSION=$(puppet help | grep 'Puppet v')
        echo "Finished installing/updating puppet to latest version: $PUPPET_VERSION"

        touch /var/puppet-init/update-puppet
        echo "Created empty file /var/puppet-init/update-puppet"
    fi
fi
