#!/bin/bash

#need to install : curl
clear
rm /tmp/exodus 2>/dev/null
curl -s https://www.exodus.io/download/ > /tmp/exodus
regex=`cat /tmp/exodus`
version=`echo ${regex#*releases/hashes-exodus} | sed 's/\.txt.*//' | sed 's/.*\-//'`

echo "derniere version d'exodus: $version"
url=`echo 'https://downloads.exodus.io/releases/exodus_'$version'_amd64.deb'`

user=`cat /etc/passwd | grep 1000 | sed 's/\:.*//'`
currentversion=`su -c "exodus --version" $user`

if [[ "$currentversion" != "$version" ]]; then
	echo "vous disposez de la version $currentversion"
	echo "or la derniere version est: version"
	ami=`whoami`
	if [[ "$ami" != "root" ]]; then
		echo "vous ne pouvez pas mettre à jour sans le compte root"
		echo "FIN"
		exit 0
	fi
	echo "voulez-vous mettre à jour?"
	choix=O
	if [[ "$choix" == "O" ]]; then
		read choix
		killall Exodus
		wget "$url" -P /tmp/
		dpkg -i "/tmp/exodus_"$version"_amd64.deb"
		echo "Exodus Updater" "Exodus was updated !"
	else
		echo "Arret"
	fi
fi

if [[ "$currentversion" == "$version" ]]; then
	echo "vous disposez déjà de la derniere version !"
fi
