#!/bin/sh

# This simple loop read the template file and writes out the environment 
# values to a servers.properties file. Defaults are set in the Dockerfile and
# can be overridden with the `-e` or `--env` flag of `docker run`
# 
# e.g.
# docker run \
#   --detach \
#   --name minecraftserver  \
#   --publish 25565:25565 \
#   --env MOTD="Welcome" \
#   minecraft:1.8.6
# 
while read SETTING
do
    eval echo $SETTING
done < server.properties.template > server.properties

# We now need to allow the user to set their memory limits before starting 
# the server. If you are not familiar with Java, be sure to understand that 
# the process will use more than MAX_MEM_POOL as this is just the size of the
# JVM's heap. Other bits of the JVM will take up more memory.
CMD="java -Xmx${MAX_MEM_POOL}M -Xms${INITIAL_MEM_POOL}M -jar minecraft_server.jar nogui"

exec $CMD

