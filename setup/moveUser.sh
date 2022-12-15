#!/bin/bash

# Récupérer la liste des utilisateurs sur le Raspberry Pi
users=$(ls /home)

# Pour chaque utilisateur...
for user in $users
do
  # Récupérer les groupes auxquels appartient l'utilisateur
  groups=$(id -Gn $user)

  # Si l'utilisateur appartient au groupe "web"...
  if echo $groups | grep -q "WEB"
  then
    # Déplacer le dossier de l'utilisateur dans le dossier "web"
    mv /home/$user /home/web/$user
  # Si l'utilisateur appartient au groupe "dev"...
  elif echo $groups | grep -q "DEV"
  then
    # Déplacer le dossier de l'utilisateur dans le dossier "dev"
    mv /home/$user /home/dev/$user
  # Si l'utilisateur appartient au groupe "marketing"...
  elif echo $groups | grep -q "MARK"
  then
    # Déplacer le dossier de l'utilsateur dans le dossier "marketing"
    mv /home/$user /home/marketing/$user
