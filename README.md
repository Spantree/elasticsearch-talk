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

#### Clone this repository

From the command line, clone this repository with:

```bash
git clone --depth 1 git@github.com:Spantree/elasticsearch-talk.git
```

![src vagrant precise64_ _elasticsearch-talk bash IR_Black 238 55 1](https://f.cloud.github.com/assets/530343/91372/a8ba382e-659c-11e2-924e-1dec8536f9ad.png)

If you're new to git and run into trouble with this step, it might be due to missing 
[github keys](https://help.github.com/articles/generating-ssh-keys).

#### Set up your vagrant instance

Then initialize your vagrant instance with:

```bash
vagrant plugin install vagrant-hostmanager
vagrant plugin install vagrant-vbguest
cd elasticsearch-talk
vagrant up
```

![vagrant up](https://github.com/Spantree/elasticsearch-talk/blob/develop/images/vagrantup.png?raw=true)

If you're feeling adventurous, we also have the option of setting up an Elasticsearch cluster (two VMs) on your machine. To do this instead, just modify the last line to be:

```
CLUSTER=true vagrant up
```

This will download a base Virtualbox Ubuntu image, set it up as a virtual machine to run locally,
and install all the tools extra tools you'll need to play along.

Please note that you may be prompted for your host system password. We aren't installing viruses or keyloggers, we promise. This is just so that the hostmanager plugin can write out mappings to your `/etc/hosts` file.  If you're feeling particularly paranoid, you can add the following entries to `/etc/hosts` manually:

```
192.168.80.100	es1.local esdemo.local
192.168.80.101	es2.local
``` 

#### Dance!

That's it.  That's all there is to it.

You should now be able to access elasticsearch on your machine from a web browser at `http://esdemo.local:9200`:

![vagrant ssh](https://github.com/Spantree/elasticsearch-talk/blob/develop/images/esbrowser.png?raw=true)

You should also be able to ssh into your virtual machine using the `vagrant ssh` command:

![vagrant ssh](https://github.com/Spantree/elasticsearch-talk/blob/develop/images/vagrantssh.png?raw=true)

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