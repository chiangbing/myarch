jargrep() {
    if [ $# -lt 2 ]; then
	echo "jargrep <parttern> <jar file> [jar file] ..."
	return 255
    fi

    _PATTERN=$1
    shift 1
	
    for f in ${@}; do
	echo -n "$f: "
	x=`jar tvf $f | grep $_PATTERN`
        if [ ! -z "$x" ]; then
            x=${x}"\n"
        fi
	printf "\n$x"
    done
}

sshto() {
        cat /etc/hosts | grep "sshto" | awk '{ print "["NR"]", $1" ("$2")" }'
        echo -n "you want to ssh to: "; read -r choice
        echo
        tohost=$(cat /etc/hosts | grep sshto | grep -v svn |  sed -n "${choice},${choice} p" | awk '{print $1}')

        lastusername=$(cat ~/.sshto 2> /dev/null | grep $tohost | awk '{print $1}')
        if [ "xx$lastusername" != "xx" ]; then
                echo -n "username[$lastusername]: "; read -r username
                echo
                if [ "xx$username" = "xx" ]; then
                        username=$lastusername
                fi
        else
                echo -n "username: "; read -r username
        fi

        if [ "xx$username" != "xx" ]; then
                cat ~/.sshto | sed -e "/$tohost/ d" > ~/.sshto.tmp
                mv ~/.sshto.tmp ~/.sshto
                echo "$username $tohost" >> ~/.sshto # record last username
                echo
                ssh ${username}@${tohost}
        else
                ssh ${USER}@${tohost}
        fi
}


switch_vpn() {
    choices=( $(cd /etc/openvpn; ls *.off) )
    seq=1
    for c in ${choices[@]}; do
        echo "[$seq] "$(basename $choices[$seq] .conf.off)
        seq=$(( $seq + 1 ))
    done

    echo -n "Choose a VPN: "
    read -r ch

    while [[ $ch -lt 0 || $ch -gt ${#choices} ]]; do
        echo "Error: invaid choice, enter a index."
        echo "Choose a VPN: "
        read -r ch
    done

    ch_vpn=${choices[$ch]}

    cur_vpn=$(cd /etc/openvpn; ls *.conf)
    if [[ ! -z $cur_vpn ]]; then
        sudo mv /etc/openvpn/$cur_vpn /etc/openvpn/${cur_vpn}".off"
    else
        echo "No VPN is on."
    fi

    sudo mv /etc/openvpn/$ch_vpn /etc/openvpn/$(basename $ch_vpn .off)
    sudo rc.d restart openvpn
}
