MCScript
========
Manage your Minecraft servers with only one script. Start, stop, execute commands etc...

How to use:
===
---
Prepare the script:
--
```sh
git clone https://github.com/BenjaminSansNom/MCScript
cd MCScript/
chmod 755 server.sh
```

Setting-up:
--
```sh
nano server.sh
```
Edit it as you want: 
```sh
#Params
SRVDEFAULT="/home/minecraft/servers/default" # If exist this path will be copy everytime you create a server else the latest beta build of Craftbukkit will be installed
SRVPATH="/home/minecraft/servers" # This path define where every servers will be installed
SERVER="server.jar" # Name of the jar file (If jar file is in default directory, need to be the same name of the default)
STARTFILE="run" # If exist this file will be execute to run server (Can be put in the default directory to auto add this file at the creation of every servers)
START="java -Xms512M -Xmx2048M -jar $SERVER" # If startfile doesn't exist, script will be execute it to run server
```
Note: All files in the default folder will be copied.