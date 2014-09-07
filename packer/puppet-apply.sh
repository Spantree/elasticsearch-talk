export FACTER_enable_marvel_agent='false'
export FACTER_do_reindex='true'
export FACTER_ssh_username='vagrant'

source /usr/local/rvm/scripts/rvm

echo "Running puppet apply"
/usr/bin/puppet apply --verbose --debug --modulepath=/etc/puppet/modules:/usr/src/elasticsearch-talk/puppet/modules --manifestdir /usr/src/elasticsearch-talk/puppet/manifests --detailed-exitcodes /usr/src/elasticsearch-talk/puppet/manifests/default.pp

# ignore the "changes" detailed exit code
if [ $? = 2 ]; then
	exit 0
else
	exit $?
fi