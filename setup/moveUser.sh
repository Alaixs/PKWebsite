#!/bin/bash

# Récupérer la liste des utilisateurs sur le Raspberry Pi
users=$(ls /home)

# Pour chaque utilisateur...
for user in $users
do
  # Récupérer le nom du groupe de l'utilisateur
  group=$(id -gn $user)

  # Si l'utilisateur appartient à un groupe...
  if [ ! -z "$group" ]
  then
    # Déplacer le dossier de l'utilisateur dans le dossier du groupe
    mv /home/$user /home/$group/$user
  fi
done
