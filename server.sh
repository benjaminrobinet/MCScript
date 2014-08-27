#!/bin/bash

#Params
SRVDEFAULT="/home/minecraft/servers/default"
SRVPATH="/home/minecraft/servers"
SERVER="server.jar"
START="java -Xms512M -Xmx2048M -jar $SERVER"
STARTFILE="run"

create() {
  ASKEDSRV=$1
  DIRECTORY="$SRVPATH/$ASKEDSRV"
  if [ ! -d "$DIRECTORY" ];
    then
      mkdir -p "$SRVPATH/$ASKEDSRV"
      if [ -d "$SRVDEFAULT" ];
        then
          cp $SRVDEFAULT/* $SRVPATH/$ASKEDSRV/
          echo "Le serveur a été créé avec les fichiers du dossier $SRVDEFAULT ."
        else
          echo "Vous n'avez spécifié aucun serveur par défaut à copier."
          echo "Le dernière version en développement de Craftbukkit va être téléchargé et utilisé."
          sleep 1
          echo "Téléchargement..."
          cd $SRVPATH/$ASKEDSRV && wget -q -O $SERVER http://dl.bukkit.org/latest-beta/craftbukkit-beta.jar
          echo "\033[32mFini\033[0m"
          sleep 1
          echo "\033[32mLe serveur a été créé avec la dernière version beta de Craftbukkit.\033[0m"
      fi
    else
      echo "\033[31mCe serveur existe déjà!\033[0m"
  fi
}

start() {
  ASKEDSRV=$1
  if screen -list | grep -q "$ASKEDSRV";
  then
    echo "Le server $ASKEDSRV est déjà lancé!"
  else
    if [ -d "$SRVPATH/$ASKEDSRV/" ];
      then
        if [ -f "$SRVPATH/$ASKEDSRV/$STARTFILE" ];
          then
            echo "Lancement de $ASKEDSRV grâce à $STARTFILE"
            cd $SRVPATH/$ASKEDSRV && screen -dmS $ASKEDSRV ./$STARTFILE
              if pgrep -f $ASKEDSRV > /dev/null
                then
                  echo "$ASKEDSRV est bien lancé."
                else
                  echo "Erreur! Impossible de lancer $ASKEDSRV!"
              fi
          else
            echo "Aucun fichier de lancement existant."
            sleep 1
            echo "Lancement de $ASKEDSRV avec comme paramètre:"
            echo "$START"
            cd $SRVPATH/$ASKEDSRV && screen -dmS $ASKEDSRV $START
        fi
      else
        echo "\033[31mCe serveur n'existe pas!\033[0m"
    fi
  fi
}

stop() {
  ASKEDSRV=$1
  if screen -list | grep -q "$ASKEDSRV";
    then
      echo "Arrêt de $ASKEDSRV"
      echo "Envoi d'une alerte sur le serveur..."
      screen -p 0 -S $ASKEDSRV -X eval "stuff 'say Le serveur va redémarrer dans 5 secondes'\015"
      sleep 1
      echo "Sauvegarde..."
      screen -p 0 -S $ASKEDSRV -X eval "stuff save-all\015"
      sleep 5
      echo "Arrêt du serveur..."
      screen -p 0 -S $ASKEDSRV -X eval "stuff stop\015"
      sleep 15
    else
      echo "$ASKEDSRV n'est pas lancé."
  fi
  if screen -list | grep -q "$ASKEDSRV";
    then
      echo "\033[31mErreur! $ASKEDSRV ne peut être stop.\033[0m"
  fi
}

sendcmd() {
  ASKEDSRV=$1
  COMMAND=$2
  if screen -list | grep -q "$ASKEDSRV";
    then
      echo "$ASKEDSRV est lancé... exécution de la commande."
      screen -p 0 -S $ASKEDSRV -X eval "stuff $COMMAND\015"
  fi
}
 
case "$1" in
  create)
    if [ $# -gt 1 ];
      then
        shift
        create "$*"
      else
        echo "Veuillez entrer un nom. (Exemple: $0 create srv01)"
    fi
  ;;

  start)
    if [ $# -gt 1 ];
      then
        shift
        start "$*"
      else
        echo "Veuillez entrer un nom. (Exemple: $0 create srv01)"
    fi
  ;;

  stop)
    if [ $# -gt 1 ];
      then
        shift
        stop "$*"
      else
        echo "Veuillez entrer un nom. (Exemple: $0 create srv01)"
    fi
  ;;

  status)
   shift
    if screen -list | grep -q "$1";
      then
        echo "$1 est lancé."
      else
        echo "$1 n'est pas lancé."
    fi
  ;;

  command)
   if [ $# -gt 2 ];
     then
      shift
      sendcmd $1 $2
     else
        echo "Veuillez entrer le nom d'un serveur et une commande. (Syntax: $0 <serveur> <commande>)"
   fi
  ;;

  *)
    echo "Utilisation: $0 {create <serveur>|start <serveur>|stop <serveur>|status <serveur>|command <serveur> <commande>}"
    exit 1
 ;;

esac
exit 0