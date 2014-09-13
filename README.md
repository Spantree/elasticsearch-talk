## Elasticsearch Talk

### Speakers

[Spantree Technology Group, LLC](http://www.spantree.net)

**Cedric Hurst:** Principal &amp; Lead Software Engineer  

**Kevin Greene:** Senior Software Engineer

**Gary Turovsky:** Senior Software Engineer

### When

Wednesday September 17th, 2014

### Where

[The Strangeloop Conference](http://www.thestrangeloop.com)
Peabody Opera Center
St Louis, MO

### Instructions for setting up this sample project

We ask that you walk through these steps before you stop by since you'll need to download stuff
and we don't want to crush the hotel bandwidth.  The project itself will likely evolve up until
the time of the presentation, but the virtual machine stuff shouldn't change too much.

#### Tools You'll Need

Install the following tools to bootstrap your environment

* Install [Git](https://help.github.com/articles/set-up-git)
* Install [VirtualBox](https://www.virtualbox.org/) (version 4.3.8 or above)
* Install [Vagrant](http://www.vagrantup.com/) (version 1.6.4 or above)

#### Clone this repository and start Vagrant

From the command line, install the `hostmanager` and `vbguest` vagrant plugins.  We use these Vagrant plugins to manage `/etc/hosts` entries and make sure you have the right version of Virtualbox Guest Additions installed:

```bash
vagrant plugin install vagrant-hostmanager
vagrant plugin install vagrant-vbguest
```

Next, you'll want to clone this repository via Git:

```bash
git clone --depth 1 https://github.com/Spantree/elasticsearch-talk.git
cd elasticsearch-talk
```

Finally, you'll want to start the Vagrant virtual machine instance:

```bash
vagrant up
```

This will download a base Virtualbox Ubuntu image, set it up as a virtual machine to run locally,
and install all the tools extra tools you'll need to play along.

Please note that you may be prompted for your host system password. We aren't installing viruses or keyloggers, we promise. This is just so that the hostmanager plugin can write out mappings to your `/etc/hosts` file.  If you're feeling particularly paranoid, you can add the following entries to `/etc/hosts` manually:

```
192.168.80.100	es1.local esdemo.local
192.168.80.101	es2.local
``` 

The whole process from end to end should look like this:

![git clone and vagrant up](images/git-clone-and-vagrant-up.gif)

If you're feeling adventurous, you also have the option of setting up a two machine Elasticsearch cluster. To do this, just modify the Vagrant up command to be:

```bash
CLUSTER=true vagrant up
```

![git up cluster](images/vagrant-up-cluster.gif)

#### Dance!

That's it.  That's all there is to it.

You should now be able to access elasticsearch on your machine from a web browser at `http://esdemo.local`:

![esdemo in a web browser](images/esdemo-web-browser.gif)

You should also be able to ssh into your virtual machine using the `vagrant ssh es1` command:

![vagrant ssh](images/vagrant-ssh-es1)

#### Stay up-to-date

As mentioned, we may be altering the vagrant configuration up until the time of the presentation, so make sure you have 
the latest changes by doing the following from your host terminal:

```
git pull
vagrant reload --provision
```

#### Shut down vagrant

When you're all done elasticsearching, you can gracefully shut down your vagrant instance by running:

```
vagrant halt
```

[![elasticsearch-talk vagrant precise64_ bash IR_Black 116 44 2-1](https://f.cloud.github.com/assets/530343/92646/fa12d092-65e6-11e2-9391-ffd039939874.png)]]

This will close the VM.

#### Remove the virtual machine from disk

If you want to conserve disk space, you can get rid of the disk images via the `destroy` command:

```
vagrant destroy
```

This repo will here for you should you need it again.

#### Show us some love

Email info@spantree.net if you run into issues.  We'd be happy to help.