## Elasticsearch Talk

#### Tools You'll Need

Install the following tools to bootstrap your environment

##### Git

Github for Windows/Mac installers on this USB drive for Mac and Windows

##### VirtualBox

Installers on this USB drive for Mac, Windows, Ubuntu and CentOS/RHEL

##### Vagrant

Installers on this USB drive for Mac, Windows and Linux

#### Clone this repository

From the command line (or Git Shell on Windows), clone this repository with:

```
git clone elasticsearch-talk.gitbundle /path/to/your/home/directort -b develop
```

#### Set up your vagrant instance

Then initialize your vagrant instance with:

```bash
cd elasticsearch-talk
vagrant plugin install vagrant-hostmanager
vagrant up
```


This will download a base Virtualbox Ubuntu image, set it up as a virtual machine to run locally,
and install all the tools extra tools you'll need to play along.  You may be required to enter your password at some point so that hostmanager can add an entry for "esdemo.local" to your /etc/hosts file.

#### Dance!

That's it.  That's all there is to it.

You should now be able to access elasticsearch on your machine from a web browser at `http://esdemo.local`:

#### Stay up-to-date

As mentioned, we may be altering the vagrant configuration up until the time of the presentation, so make sure you have the latest changes by doing the following from your host terminal:

```
git pull
vagrant reload
vagrant provision
```

#### Shut down vagrant

When you're all done elasticsearching, you can gracefull shut down your vagrant instance by running:

```
vagrant halt
```

This will close the VM.

#### Remove the virtual machine from disk

If you want to conserve disk space, you can get rid of the disk images at `~/.vagrant.d` 
and `~/VirtualBox VMs`:

This repo will here for you should you need it again.

#### Show us some love

Email info@spantree.net if you run into issues.  We'd be happy to help.



