## Elasticsearch Talk

The following repository corresponds to [Spantree](http://www.spantree.net)'s Elasticsearch workshop. It uses Docker and Docker Compose to launch number of containers for exploration of Elasticsearch. It also contains all the slides in our deck, courtesy of [reveal.js](https://github.com/hakimel/reveal.js/).

### Screencast

If you're more of a visual and auditory learner, we've got you covered! We recorded a [live version](http://bit.ly/strangeloop-elasticsearch) of this talk during our [workshop at the StrangeLoop Conference](https://thestrangeloop.com/sessions/getting-started-with-elasticsearch) in September 2014. Some of the artifacts have since been updated for later versions of Elasticsearch.

### Authors

**Cedric Hurst:** Principal &amp; Lead Software Engineer<br/>
**Kevin Greene:** Senior Software Engineer<br/>
**Gary Turovsky:** Senior Software Engineer Emeritus<br/>
**Jonathan Freeman:** Senior Software Engineer<br/>

### Instructions for setting up this sample project

We ask that you walk through these steps before you stop by since you'll need to download stuff
and we don't want to crush the hotel bandwidth.  The project itself will likely evolve up until
the time of the presentation, but the Docker stuff shouldn't change too much.

#### Tools You'll Need

Install the following tools to bootstrap your environment

* Install [Git](https://help.github.com/articles/set-up-git)
* If on Mac or Windows, install Boot2Docker
  * [Mac](https://docs.docker.com/installation/mac/)
  * [Windows](https://docs.docker.com/installation/windows/)
* Install [Docker Compose](https://docs.docker.com/compose/)

#### Launch a boot2docker machine

For some of the labs, we'll need a little bit more RAM than the 2GB normally provided, which we can do by providing the `-m 4096` flag. We'll also want to create a local host entry for our boot2docker vm so we can access Elasticsearch and various other services from our host machine. If you're on Windows, the syntax may be slightly different and you may have to manually write out your `/etc/hosts` entry. If you know a better way, pull requests are very welcome.

```bash
boot2docker init -m 4096
boot2docker up
$(boot2docker shellinit)
echo "$(boot2docker ip) estalk.spantree.local esdemo.local" | sudo tee -a /etc/hosts
```

#### Clone this repository and start Docker Compose

```bash
git clone --depth 1 https://github.com/Spantree/elasticsearch-talk.git
cd elasticsearch-talk
docker-compose up
```

#### Dance!

That's it.  That's all there is to it.

You should now be able to access elasticsearch on your machine from a web browser at `http://estalk.spantree.local`:

![esdemo in a web browser](images/esdemo-web-browser.gif)

#### Stay up-to-date

As mentioned, we may be altering the vagrant configuration up until the time of the presentation, so make sure you have
the latest changes by doing the following from your host terminal:

```
git pull
docker pull spantree/elasticsearch-talk-es
docker pull spantree/elasticsearch-talk-www
docker pull spantree/logstash-star-wars-kid
docker compose up
```

#### Show us some love

Email info@spantree.net if you run into issues.  We'd be happy to help.
