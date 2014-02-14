## ElasticSearch Talk

### Speakers
**Cedric Hurst:** Principal & Lead Software Engineer at Spantree  

**Malynda Chizek Frouard** Junior Software Engineer and PhD in Astrophysics 

**Kevin Greene:** Senior Software Engineer and Patent Holder 

**Gary Turovsky:** Senior Software Engineer 

### When

Tuesday February 18th, 2014

### Where

Spantree Technology Group, LLC  
1144 W Fulton Market, Suite 120
Chicago, IL 60607

### Instructions for setting up this sample project

We ask that you walk through these steps before you stop by since you'll need to download stuff
and we don't want to crush our office bandwidth.  The project itself will likely evolve up until
the time of the presentation, but the virtual machine stuff shouldn't change too much.

#### Tools You'll Need

Install the following tools to bootstrap your environment

* Install [Git](https://help.github.com/articles/set-up-git)
* Install [VirtualBox](https://www.virtualbox.org/) (we used version 4.3)
* Install [Vagrant](http://www.vagrantup.com/) (we used version 1.3.5)

#### Clone this repository

From the command line, clone this repository with:

```bash
git clone --recursive git@github.com:Spantree/elasticsearch-talk.git
```

![src vagrant precise64_ _elasticsearch-talk bash IR_Black 238 55 1](https://f.cloud.github.com/assets/530343/91372/a8ba382e-659c-11e2-924e-1dec8536f9ad.png)

If you're new to git and run into trouble with this step, it might be due to missing 
[github keys](https://help.github.com/articles/generating-ssh-keys).

#### Set up your vagrant instance

Then initialize your vagrant instance with:

```bash
cd elasticsearch-talk
vagrant plugin install vagrant-hostmanager
vagrant up
```

![vagrant up](https://github.com/Spantree/elasticsearch-talk/blob/develop/images/vagrantup.png?raw=true)


This will download a base Virtualbox Ubuntu image, set it up as a virtual machine to run locally,
and install all the tools extra tools you'll need to play along.  You may be required to enter your password at some point so that hostmanager can add an entry for "esdemo.local" to your /etc/hosts file.

#### Dance!

That's it.  That's all there is to it.

You should now be able to access elasticsearch on your machine from a web browser at `http://esdemo:9200`:

![localhost_9200-1](https://f.cloud.github.com/assets/530343/91846/5535201a-65b0-11e2-9661-05801d1d4bbd.png)

You should also be able to ssh into your virtual machine using the `vagrant ssh` command:

![elasticsearch-talk vagrant precise64_ ssh IR_Black 238 55 1-1](https://f.cloud.github.com/assets/530343/91387/08a27828-659d-11e2-81bc-ea9facd46221.png)

#### Stay up-to-date

As mentioned, we may be altering the vagrant configuration up until the time of the presentation, so make sure you have 
the latest changes by doing the following from your host terminal:

```
git pull
vagrant reload
vagrant provision
```

![elasticsearch-talk vagrant precise64_ bash IR_Black 116 44 2](https://f.cloud.github.com/assets/530343/92644/d63de4a4-65e6-11e2-8c68-22d4db4ecf9c.png)

#### Shut down vagrant

When you're all done elasticsearching, you can gracefull shut down your vagrant instance by running:

```
vagrant halt
```

[![elasticsearch-talk vagrant precise64_ bash IR_Black 116 44 2-1](https://f.cloud.github.com/assets/530343/92646/fa12d092-65e6-11e2-9391-ffd039939874.png)]]

This will close the VM.

#### Remove the virtual machine from disk

If you want to conserve disk space, you can get rid of the disk images at `~/.vagrant.d` 
and `~/VirtualBox VMs`:

![elasticsearch-talk](https://f.cloud.github.com/assets/530343/92637/39ba1012-65e6-11e2-873f-3e756b54cd70.png)

![elasticsearch-talk_1358999479](https://f.cloud.github.com/assets/530343/92638/4fdf39e4-65e6-11e2-81bd-9d281d9fa412.png)

This repo will here for you should you need it again.

#### Show us some love

Email info@spantree.net if you run into issues.  We'd be happy to help.



