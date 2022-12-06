#Par Duprat Dorian et Piekarz Alexis
#Date: 27/11/2022
#Description: Script d'installation de l'environnement de travail pour Tek-it-Izi complétement automatisé
#Version: 1.6
#!/bin/bash

echo "Bienvenue dans le script d'installation de l'environnement de travail pour Tek-it-Izi"
echo "Veuillez patienter pendant l'installation de l'environnement de travail"

echo -ne '[                          ](0%)\r'
#Update system
sudo apt-get update &> logs.txt
echo -ne '[#####                     ](20%)\r'
sudo apt-get upgrade &> logs.txt
echo -ne '[#############             ](52%)\r'

#Install firefox browser
sudo apt-get install -y firefox &> logs.txt
echo -ne '[###############           ](60%)\r'

#Install git
sudo apt-get install -y git &> logs.txt
echo -ne '[##################        ](70%)\r'

#Install vscode
sudo snap install --classic code &> logs.txt
echo -ne '[#####################     ](80%)\r'


sudo groupadd CHEFS
sudo install -d -m 0770 -g CHEFS "/home/partageChefs"
sudo mkdir -m 0777 "/home/partageTous"
{
    read
    while IFS=\; read -r firstname lastname password group; do
        lowGroup="${group,,}"
        shareFolder="partage${lowGroup^}"
        if [ "$group" = "MARK" ]; then
            group="MARKETING"
        fi
        firstname="${firstname,,}"
        lastname="${lastname,,}"
        username="${firstname:0:1}${lastname:0:6}"
        basedir="/home/${group,,}"
        homedir="$basedir/$username"
        if [ $(getent group "$group") ]; then
          sudo useradd -N -G "$group" -m -b "$basedir" -d "$homedir" -m -k "/skel" "$username"
          echo "$username:$password" | sudo chpasswd
          sudo chmod 700 "$homedir"
          sudo ln -s "$basedir/$shareFolder" "$homedir"
          sudo ln -s "/home/partageTous" "$homedir"
        else
          sudo groupadd "$group"
          sudo mkdir "$basedir"
          sudo useradd -N -G CHEFS,"$group" -m -b "$basedir" -d "$homedir" -k "/skel" "$username"
          echo "$username:$password" | sudo chpasswd
          sudo chmod 700 "$homedir"
          sudo mkdir "$basedir/$shareFolder"
          sudo chown "$username":"$group" "$basedir/$shareFolder"
          sudo chmod 770 "$basedir/$shareFolder"
          sudo ln -s "$basedir/$shareFolder" "$homedir"
          sudo ln -s "/home/partageChefs" "$homedir"
          sudo ln -s "/home/partageTous" "$homedir"
        fi
    done 
} < collabos.csv

echo -ne '[##########################](100%)\r'
echo "Script is done"
