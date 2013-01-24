## ElasticSearch Talk

### Speakers
**Cedric Hurst:** Principal & Lead Software Engineer at Spantree  
**Gary Turovsky:** Senior Software Engineer at Spantree & Smartypants Ph.D. Candidate at UIC

### When

Thursday January 24, 2013 at 7:00PM

### Where

Spantree Technology Group, LLC  
813 W Randolph St, Suite 301  
Chicago, IL 60607

We're the office building with the red hallway directly right of the entrance to Girl & The Goat.

Buzz #9 at the door and take the elevator to the third floor.

### Instructions for setting up this sample project

We ask that you walk through these steps before you stop by on Thursday since you'll need to download stuff
and we don't want to crush our office bandwidth.  The project itself will likely evolve up until
the time of the presentation, but the virtual machine stuff shouldn't change too much.

#### Tools You'll Need

Install the following tools to bootstrap your environment

* Install [Git](https://help.github.com/articles/set-up-git)
* Install [VirtualBox](https://www.virtualbox.org/)
* Install [Vagrant](http://www.vagrantup.com/)

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
vagrant up
```

![elasticsearch-talk vagrant precise64_ _elasticsearch-talk bash IR_Black 212 52 1](https://f.cloud.github.com/assets/530343/91359/57051f12-659c-11e2-8a32-eca2d597691e.png)


This will download a base Virtualbox Ubuntu image, set it up as a virtual machine to run locally,
and install all the tools extra tools you'll need to play along.

#### Dance!

That's it.  That's all there is to it.

You should now be able to access elasticsearch on your machine from a web browser at `http://localhost:9200`:

![localhost_9200-1](https://f.cloud.github.com/assets/530343/91846/5535201a-65b0-11e2-9661-05801d1d4bbd.png)

You should also be able to ssh into your virtual machine using the `vagrant ssh` command:

![elasticsearch-talk vagrant precise64_ ssh IR_Black 238 55 1-1](https://f.cloud.github.com/assets/530343/91387/08a27828-659d-11e2-81bc-ea9facd46221.png)

#### Show us some love

Email info@spantree.net if you run into issues.  We'd be happy to help.

### Updating to your vagrant configuration

As mentioned, we may be altering the vagrant configuration up until the time of the presentation, so make sure you have 
the latest changes by doing the following from your host terminal:

```
git pull origin master
vagrant reload
```
