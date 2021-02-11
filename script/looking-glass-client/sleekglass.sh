#!/bin/bash
#Sleekglass is a simple client for Looking Glass
# Version 0.2

#pkexec env DISPLAY=$DISPLAY XAUTHORITY=$XAUTHORITY "/home/home/mega/code/looking-glass-client/sleekglass.sh"
#looking-glass-client -c 127.0.0.1 -p 5900

#define root user folder
dir=$(cd -P -- "$(dirname -- "$0")" && pwd -P)
#get current user
ami=`whoami`
#get current script name
me=`basename "$0"`
usr=`echo $LOGNAME`
# (optional) restore the good iptables rules for pci passthrough
#iptables-restore < /etc/iptables/rules.v4

#root access verification
#if [[ "$ami" != "root" ]]; then
	#zenity --error --title="root not detected" --text="User $ami was not root"
	#exit 0
#fi

#Get screen information
xrandr | grep " connected " | cut -f1 -d " " > /tmp/.sleekglass-screen.log

function settingsempty {
	#Window form
	echo "execution settingsempty"
	yad --center --width=500 --height=100 --title="Sleek glass - Looking Glass Client" --form --columns=2 \
	--field="IP:" "127.0.0.1" --field="PORT:" "5900" \
	--item-separator="," --field="Output screen:":CB "$(paste -s -d"," < /tmp/.sleekglass-screen.log)" \
	--field="Fullscreen:CB" Yes,No \
	--field="Show FPS:CB" No,Yes \
	--field="Borderless:CB" Yes,No \
	--field="FPS LIMIT:CB" 150,250,300,400,500,1000,2000,2500 \
	--field="disable keyboard/mouse:CB" Yes,No \
	--field="show mouse above the L-G window:CB" Yes,No > /home/$usr/.config/sleekglass/config.ini

	settingsvalue=`cat /home/$usr/.config/sleekglass/config.ini`
	> /home/$usr/.config/sleekglass/config.json
	
	#Delimitation
	for demilitation in $(echo $settingsvalue | tr "|" "\n")
	do
  			echo "$demilitation" >> /home/$usr/.config/sleekglass/config.json
	done
	verif=`cat /home/$usr/.config/sleekglass/config.ini`
	if [[ "$verif" != "" ]]; then
		notify-send -i "$dir/icons/Logo.png" "Sleekglass" "All settings are saved for your future connections"
	fi
}

function about {
	#Window form
	zenity --info --title="Sleek glass - Looking Glass Client" --width=100 --height=100 --no-wrap --text="<big><b>Soft by Sleek:\n<span color=\"red\">for opensource community</span>\
	</b></big>\n\nSleekGlass is a simple tool to connect easily at your VGA passthrough with looking-glass-client.\n
	You can easly setup your settings, open and close windows.<b>\n</b>\n
	Join our discord server: https://discord.gg/Kp6Z27n \n
	Enjoy :)
	ʞǝǝlS"
}

function emptyornot {
	#Check if config exist
	configfile=/home/$usr/.config/sleekglass/config.ini
	echo "mon path: /home/$usr/.config/sleekglass/config.ini"

	if [ ! -f "$configfile" ]; then
	    #Create config file
	    mkdir -p /home/$usr/.config/sleekglass/ 2> /dev/null
	    settingsempty
	fi
	emptyconf=`cat /home/$usr/.config/sleekglass/config.ini`
	while [[ "$emptyconf" == "" ]]; do
		settingsempty
		emptyconf=`cat /home/$usr/.config/sleekglass/config.ini`
	done
}
emptyornot

function createconfig {
	> /home/$usr/.config/sleekglass/config.json
	settingsvalue=`cat /home/$usr/.config/sleekglass/config.ini`
	#Delimitation
	for demilitation in $(echo $settingsvalue | tr "|" "\n"); do echo "$demilitation" >> /home/$usr/.config/sleekglass/config.json; done

	#Get settings
	IP=`cat /home/$usr/.config/sleekglass/config.json | awk 'NR == 1'`
	Port=`cat /home/$usr/.config/sleekglass/config.json | awk 'NR == 2'`
	Screenopening=`cat /home/$usr/.config/sleekglass/config.json | awk 'NR == 3'`; 
	Fullscreen=`cat /home/$usr/.config/sleekglass/config.json | awk 'NR == 4'`
	Showfps=`cat /home/$usr/.config/sleekglass/config.json | awk 'NR == 5'`
	Borderless=`cat /home/$usr/.config/sleekglass/config.json | awk 'NR == 6'`
	FPSlimit=`cat /home/$usr/.config/sleekglass/config.json | awk 'NR == 7'`
	mousekeyboard=`cat /home/$usr/.config/sleekglass/config.json | awk 'NR == 8'`
	mouseaboseLGwindows=`cat /home/$usr/.config/sleekglass/config.json | awk 'NR == 9'`

	#define the primary screen
	xrandr --output $Screenopening --primary

	#Config option
	if [[ "$Fullscreen" == "No" ]]; then Fullscreen2=""; else Fullscreen2="-F"; fi
	if [[ "$Showfps" == "No" ]]; then Showfps2=""; else Showfps2="-k"; fi
	if [[ "$Borderless" == "No" ]]; then Borderless2=""; else Borderless2="-d"; fi
	if [[ "$mousekeyboard" == "No" ]]; then mousekeyboard2=""; else mousekeyboard2="-s"; fi
	if [[ "$mouseaboseLGwindows" == "No" ]]; then mouseaboseLGwindows2=""; else mouseaboseLGwindows2="-M"; fi
}

function startstream {
	createconfig;
	pid=$! 2> /dev/null
	#windows flox
	echo "executed command: looking-glass-client -c $IP -p $Port $Fullscreen $Showfps $Borderless -K $FPSlimit $mousekeyboard $mouseaboseLGwindows"
	/usr/local/bin/looking-glass-client -c $IP -p $Port $Fullscreen2 $Showfps2 $Borderless2 $FPSlimit $mousekeyboard2 $mouseaboseLGwindows2 &
	pid=$!
}

function settings {
	md5check1=`md5sum /home/$usr/.config/sleekglass/config.ini | sed 's/ .*//'`

	#Window form
	notempty=`yad --center --width=500 --height=100 --title="Sleek glass - Looking Glass Client" --form --columns=2 \
	--field="IP:" "$IP" --field="PORT:" "$Port" \
	--item-separator="," --field="Output screen:":CB $Screenopening,"$(paste -s -d"," < /tmp/.sleekglass-screen.log)" \
	--field="Fullscreen:CB" $Fullscreen,Yes,No \
	--field="Show FPS:CB" $Showfps,No,Yes \
	--field="Borderless:CB" $Borderless,Yes,No \
	--field="FPS LIMIT:CB" $FPSlimit,250,300,400,500,1000,2000,2500 \
	--field="disable keyboard/mouse:CB" $mousekeyboard,Yes,No \
	--field="show mouse above the L-G window:CB" $mouseaboseLGwindows,Yes,No`
	if [[ "$notempty" != "" ]]; then
		echo "$notempty" > /home/$usr/.config/sleekglass/config.ini
		notify-send -i "$dir/icons/Logo.png" "Sleekglass" "All settings are saved for your future connections"
	fi
}

#kill lookinglass function
function pkid {
	sleep 1
	killppid=`cat /tmp/ppid`; killppid2=`cat /tmp/ppid2`
	kill -9 $killppid2 2>/dev/null; sleep 1; kill -9 $killppid 2>/dev/null
	ppid=`ps aux | grep "SLEEKGLASS" | grep "looking-glass" | sed 's/\  0.*//' | sed -e "s/root      //g"`
	# CHANGE YOUR USERNAME UNDER THIS LINE (here "home")
	ppid2=`ps aux | grep "sleekglass.sh" | grep pkexec | sed 's/\  0.*//' | sed -e "s/home      //g"`
	echo "$ppid" > /tmp/ppid; echo "$ppid2" > /tmp/ppid2;
}

function stopstream {
	kill -9 $pid 2>/dev/null
}
pkid &

#windows form menu
while true;
do
yad --title="SLEEKGLASS : a simple client for Looking Glass" \
	--center --button="Start viewing $ami!$dir/icons/Start.png":1 \
	--button="Stop viewing!$dir/icons/Stop.png":2 \
	--button="settings!$dir/icons/Settings.png":3 \
	--button="About!$dir/icons/About.png":4 \
	--button="Close!$dir/icons/Close.png":5
	action=$?
	if [[ "$action" == "1" ]]; then
		stopstream
		createconfig
		startstream
	elif [[ "$action" == "2" ]]; then
		stopstream
	elif [[ "$action" == "3" ]]; then
		createconfig;
		settings;
	elif [[ "$action" == "4" ]]; then
		about
	elif [[ "$action" == "5" ]]; then
		stopstream
		kill -9 $$
		exit 0;
	fi
done
