#!/bin/bash

prog=$(zenity  --list  --text "Programme démarrage" --width=500 --height=420 --checklist  --column "Check" \
--column "options" TRUE "tor" TRUE "windows10-gaming" TRUE "firefox" TRUE "thunderbird" FALSE "teamspeak" TRUE "discord" FALSE "wire" FALSE "discord-canary" FALSE "discordimage" TRUE "steam" TRUE "screencloud" \
FALSE "pidgin" FALSE "bitcoin" TRUE "MEGA-SYNC" FALSE "cryptocat" FALSE "Ethereum" FALSE "vmware" FALSE "skype" --separator=":");

# permet denlever les deux point : et de faire un retour chariot
echo $prog | sed -e "s/:/\n/g" > .cmd

cat .cmd | while read ligne
do
	case "$ligne" in
		tor)
			/home/home/tor-browser_fr/Browser/start-tor-browser &
			;;
		windows10-gaming)
			virt-manager &
			;;
		teamspeak)
			/bin/ts3 &
			;;
		discord)
			/usr/share/discord/Discord &
			;;
		wire)
			/opt/Wire/wire-desktop %U &
			;;
		discord-canary)
			/usr/share/discord-canary/DiscordCanary &
			;;
		discordimage)
			screen -S discordimage /home/home/Téléchargements/discord-image/discord-image-downloader-go-linux-amd64 &
			;;
		firefox)
			firefox &
			;;
		thunderbird)
			thunderbird &
			;;
		steam)
			steam &
			;;
		screencloud)
			env BAMF_DESKTOP_FILE_HINT=/var/lib/snapd/desktop/applications/screencloud_screencloud.desktop /snap/bin/screencloud %U &
			;;
		pidgin)
			pidgin &
			;;
		cryptocat)
			/home/home/Cryptocat-linux-x64/Cryptocat.AppImage &
			;;
		bitcoin)
			bitcoin-qt %u &
			;;
		Ethereum)
			"/opt/Ethereum Wallet/ethereumwallet" &
			;;
		vmware)
			/usr/bin/vmware %U &
			;;
		skype)
			/usr/bin/skypeforlinux %U &
			;;
		MEGA-SYNC)
			sleep 20 && megasync &
			;;
		*)
			echo "je ne trouve pas: $ligne"
			;;
	esac
done

rm .cmd
