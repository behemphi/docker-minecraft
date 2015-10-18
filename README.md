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

You can check [Docker Hub]() for an up to date list of tags, but here is 
partial immedate gratification:

* 1.8.6-a
* snapshot-1.9.0-15w41a

```
docker run \
    --detach \
    --publish 25565:25565 \
    behemphi/docker-minecraft:latest
```

The above is a great way to run a server quick and dirty, however it is 
_very_ prone to data loss. This tends to interfere with hero status, so 
if you are ready for some more advanced Docker see the Data Management
section below.

## Data Management

If you were to upgrade from 1.8.6 to 1.8.8 by simply rebuilding the image 
with the new 1.8.8 binary and starting a new container, you would not 
have your data. It's in the old container. 

Docker suggests several ways to deal with this.  Here are the specific
mechanics of the [dedicated data volume](https://docs.docker.com/userguide/dockervolumes/) 
method:

Before starting the Minecraft container as above, first start a container
that will serve as just a data volume:

```
docker run \
    --detach \
    --p 25565:25565 \
    --volume /minecraft/WORLD \
    --name minecraft-data 
    behemphi/minecraft-1.8.6
```

Note that this command exposes `/minecraft/WORLD` as a volume and gives the 
running container a specific name `minecraft-data`.  

Now stop (not remove) the  `minecraft-data` container.  It need not be running
to store data and this keeps you from incurring all the weight of Java there.

```
docker stop minecraft-data
```

Now start the Mincraft server:


```
docker run \
    --detach \
    --publish 25565:25565 \
    --volumes-from minecraft-data
    behemphi/docker-minecraft:latest
```

Note that we are telling this container to using volumes defined in the
previously started/stopped `minecraft-data`.

Now your data is (somewhat) safe in the data volume.

# How To

Of course, the first question you will get after starting a server is, 
"Mom/Dad can you make it so I can play in creative mode?" After that it will
be "Can I change the message of the day," or "Can we run a snapshot?"

## Running More Than One Server

Now that Minecraft is in a container, you can run multiple different kinds
of server easily from the same machine.  Here is an example command for 
starting a creative server:

```
docker run \
    --detach \
    --publish 22334:25565 \
    --env GAMEMODE=1 \
    --env FORCE_GAMEMODE=true \
    --volumes-from minecraft-creative-data \
    --name minecraft-creative-1.8.6 
    behemphi/docker-minecraft
```

The above command is how I run a creative server container.  Things to note:

* `--publish` - I needed a different port since the original (survival) is 
  running on the standard port 25565
* `--env GAMEMODE` - sets the server property to creative (`1`) 
* `--env FORCE_GAMEMODE` - enforces this always being a creative server 
  when the client connects.
*  `--volumes-from` - assumes you have created a dedicated data volume called
  `minecraft-creative-data` the same way we did above.


## Running a Snapshot

If all you want to do is run an available snapshot, you need only:


```
docker run \
    --detach \
    --publish 25565:25565 \
    behemphi/docker-minecraft:snapshot-1.9.0-15w41a
```

You can go through the usual steps outlined above if you would like to keep 
your data in a dedicated volume. 

Things get much more interesting if you would like to use the data from your
existing world. 

*DO NOT* point a snapshot at your existing data container. If there is a bug in
the snapshot that corrupts data, then your data is gone. You've been warned.

Instead take a backup of the `minecraft-data` volume by following the directions
found toward the bottom of the page in the heading 
[Backup, restore, or migrate data volumes](https://docs.docker.com/userguide/dockervolumes/)

Then follow the same steps in starting/stop the dedicated volume, and then the 
server container.  

# License

MIT
