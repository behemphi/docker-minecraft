# Purpose

To become a hero to my children and, to a lesser extent, their friends. This
will be accomplished by being able to run multiple minecraft servers.

# Overview 

This project was sponsored by my employer, [StackEngine](http://stackengine.com)
as part of the Docker 101 series of tutorials.  If you would like
details about how and why this container is constructed the way it is, see
the [supporting blog post](http://stackengine.com/docker-101-03-2-containerizing-legacy-applications-continued/)

# Usage

The run command below will get you the latest snapshot my kids have asked me
to containerize.  


```
docker run \
    --detach \
    --publish 25565:25565 \
    --name minecraft_1.8.6 \
    behemphi/docker-minecraft:latest
```

# How To

If the Docker command is unfamiliar to you, I recommend simply running a CoreOS
cloud server at Digial Ocean. Docker is native to the CoreOS operating system
and you will need only cut and past the command above to have it work.

Look for a blog on exactly this in the future.

# License

MIT
