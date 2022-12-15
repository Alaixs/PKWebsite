#!/bin/bash
#Par Duprat Dorian et Piekarz Alexis
#Date: 27/11/2022
#Description: Script d'installation de l'environnement de travail pour Tek-it-Izi complétement automatisé
#Version: 1.8

echo "Bienvenue dans le script d'installation de l'environnement de travail pour Tek-it-Izi"
echo "Veuillez patienter pendant l'installation de l'environnement de travail"

wget https://raw.githubusercontent.com/Alaixs/PKWebsite/master/setup/collabos.csv

clear

#Update system
sudo apt-get update 

sudo apt-get -y upgrade

#Install firefox browser
sudo apt-get install -y firefox

#Install git
sudo apt-get install -y git 

#Install vscode
sudo apt install -y code

sudo groupadd CHEFS
sudo install -d -m 0770 -g CHEFS "/home/partageChefs"
sudo mkdir -m 0777 "/home/partageTous"
# créer les dossiers de partage
mkdir -p /home/DEV/partageDev
mkdir -p /home/WEB/partageWeb
mkdir -p /home/MARK/partageMark
# vérifier si l'utilisateur est root
if [ "$(id -u)" != "0" ]; then
  echo "Ce script doit être exécuté en tant que root" 1>&2
  exit 1
fi

# créer les groupes si nécessaire
if ! getent group DEV >/dev/null; then
  groupadd DEV
fi
if ! getent group MARK >/dev/null; then
  groupadd MARK
fi
if ! getent group WEB >/dev/null; then
  groupadd WEB
fi

while IFS=';' read -r firstname lastname password department; do
  # générer le nom d'utilisateur
  # utilise la commande cut pour extraire la première lettre du prénom
  username=$(echo "$firstname" | cut -c1)$lastname
  # utilise la commande tr pour mettre le nom d'utilisateur en minuscule
  username=$(echo $username | tr '[:upper:]' '[:lower:]')
  useradd -c "$firstname $lastname" -m $username
  # créer l'utilisateur avec le mot de passe spécifié
  useradd -m -s /bin/bash -p "$(openssl passwd -1 "$password")" "$username"
  # créer les répertoires "Documents", "Images" et "Téléchargements"
  mkdir -p /home/$username/Documents
  mkdir -p /home/$username/Images
  mkdir -p /home/$username/Téléchargements
  # ajouter l'utilisateur au groupe correspondant
  case "$department" in
    DEV) usermod -aG DEV "$username";;
    MARK) usermod -aG MARK "$username";;
    WEB) usermod -aG WEB "$username";;
  esac
  # déplacer le dossier de l'utilisateur dans le dossier de son groupe
  mv /home/$username/* /home/$department/
  # supprimer le dossier de l'utilisateur
  rmdir /home/$username
done < collabos.csv

# définir les permissions des dossiers de chaque groupe
chgrp -R DEV /home/DEV
chmod -R g-rwx,o-rwx /home/DEV

chgrp -R MARK /home/MARK
chmod -R g-rwx,o-rwx /home/MARK

chgrp -R WEB /home/WEB
chmod -R g-rwx,o-rwx /home/WEB

#CHANGER LE NOM DES DOSSIERS DE PARTAGE
mv /home/DEV /home/dev
mv /home/MARK /home/marketing
mv /home/WEB /home/web

clear

echo "Script fini il n'y a eu aucune erreur.'"
