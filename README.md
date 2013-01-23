## ElasticSearch Talk

### Speakers
* Cedric Hurst (Principal & Lead Software Engineer at Spantree)
* Gary Turovsky (Senior Software Engineer at Spantree & Ph.D. Candidate at UIC)

### When

Thursday January 24, 2013 at 7:00PM

### Where

Spantree Technology Group, LLC
813 W Randolph St, Suite 301
Chicago, IL 60607

Buzz #9 at the door and take the elevator to the third floor.

## Instructions for setting up this sample project

We ask that you run these before you stop by on Thursday since you'll need to download stuff
and we don't want to crush our office bandwidth.  The project itself will likely evolve up until
the time of the presentation, but the virtual machine stuff shouldn't change too much.

### Tools You'll Need

* [Install Git](https://help.github.com/articles/set-up-git)
* Install [VirtualBox](https://www.virtualbox.org/)
* Install [Vagrant](http://www.vagrantup.com/)

### Clone this repository

* From the command line, clone this repository with:

```bash
git clone --recursive git@github.com:Spantree/elasticsearch-talk.git
```

### Set up your vagrant instance

Then initialize your vagrant instance with:

```bash
cd elasticsearch-talk
vagrant up
```

This will download a base Ubuntu Lucid installation image, set it up as a VirtualBox VM,
and install all the tools you'll need to play along.

### Dance!

That's it.  That's all there is to it!  You should now be able to access elasticsearch on your machine at
`http://localhost:9200`.

Email info@spantree.net if you run into issues.  We'd be happy to help.
