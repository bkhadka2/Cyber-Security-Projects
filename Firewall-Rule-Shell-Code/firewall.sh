#!/usr/bin/sudo bash

function mainMenu {
    option=$(whiptail --title "IPTABLES FIREWALL" --menu "Choose an option" 15 65 8 \
    "1:" "Display Firewall Rules" \
    "2:" "Add Rules Manually" \
    "3:" "Choose Rules" \
    "4:" "Delete Firewall Rules" \
    "5:" "Display All rules in HTML page" \
    "6:" "Quit"  3>&1 1>&2 2>&3)
    status=$?
    if [[ $option == "1:" ]]; then
        choice=$(whiptail --title "IPTABLES FIREWALL Rules" --menu "Choose an option" 15 65 8 \
        "a:" "INPUT Rules" \
        "b:" "OUTPUT Rules" \
        "c:" "FORWARD Rules" \
        "d:" "Display All Rules" \
        "e:" "Go To Main Menu"  3>&1 1>&2 2>&3)
        if [[ $choice == "a:" ]]; then
            displayINPUT
            optionForDifferentRules

        elif [[ $choice == "b:" ]]; then
            displayOUTPUT
            optionForDifferentRules

        elif [[ $choice == "c:" ]]; then
            displayFORWARD
            optionForDifferentRules

        elif [[ $choice == "d:" ]]; then
            displayAllRules
            optionForDifferentRules
            
        else
            mainMenu
        fi

    elif [[ $option == "2:" ]]; then
        optionForAddingRules
        
    elif [[ $option == "3:" ]]; then
        builtInFirewallOptions

    elif [[ $option == "4:" ]]; then
        optionForDeletingRules

    elif [[ $option == "5:" ]]; then
        htmlFile > fwall.html
        username=$(whiptail --inputbox "Type in your Username For Computer" 8 78 --title "Username Box" 3>&1 1>&2 2>&3)
        sudo su $username firefox fwall.html
        mainMenu

    elif [[ $status = 1 ]]; then
        exit 0;

    else
        exit 0

    fi
}

function displayINPUT {
    a=$(sudo iptables -L INPUT --line-numbers)
    whiptail --title "INPUT Firewall Rules" --msgbox "Listed are the INPUT rules:\n $a" 20 78
}

function displayOUTPUT {
    a=$(sudo iptables -L OUTPUT --line-numbers)
    whiptail --title "OUTPUT Firewall Rules" --msgbox "Listed are the OUTPUT rules:\n $a" 20 78
}

function displayFORWARD {
    a=$(sudo iptables -L FORWARD --line-numbers)
    whiptail --title "FORWARD Firewall Rules" --msgbox "Listed are the FORWARD rules:\n $a" 20 78
}

function displayAllRules {
    a=$(sudo iptables -L --line-numbers)
    whiptail --title "FORWARD Firewall Rules" --msgbox "Listed are the Firewall rules:\n $a" 35 90
}

function optionForAddingRules {
    command=$(whiptail --inputbox "Type in the command" 8 78 --title "Command Box" 3>&1 1>&2 2>&3)
    status=$?
    if [[ $command == "" ]]; then
            whiptail --title "Messsage box" --msgbox "NO Rule added! Empty provided!! " 20 78

    elif [[ $status = 1 ]]; then
        whiptail --title "Messsage box" --msgbox "No Rule provided to add " 20 78

    else
        error=$(echo $command | grep -i "Bad argument") || $(echo $command | grep -i "command not found")
        errorStatus=$?
        if [[ $errorStatus = 1 ]]; then
            whiptail --title "Messsage box" --msgbox "No Such Rule exist " 20 78
        else
            whiptail --title "Messsage box" --msgbox "$command INPUT rule added!! " 20 78
            $command
        fi
    fi 
    optionForDifferentRules    
    mainMenu
}

function htmlFile {
    TITLE=$(hostname)
    a=$(sudo iptables -S INPUT)
    b=$(sudo iptables -S OUTPUT)
    c=$(sudo iptables -S FORWARD)
cat <<- _EOF_
        <html>
            <head>
                <title>Firewall Rules $TITLE</title>
            </head>
            <body style="background-color:purple;">
                <h1 style="color:white; text-align:center;">Firewall Rules: $TITLE</h1>
                <br>
                <br>
                <br>
                <h2 style="color:white; text-align:center;"> INPUT RULES: </h2>
                <p style="text-align:center; font-size:28px;"> $a </p>       
                <h2 style="color:white; text-align:center;"> OUTPUT RULES: </h2>
                <p style="text-align:center; font-size:28px;"> $b </p>
                <h2 style="color:white; text-align:center;"> FORWARD RULES: </h2>     
                <p style="text-align:center; font-size:28px;"> $c </p>
            </body>
        </html>
_EOF_
}

function optionForDeletingRules {
    op=$(whiptail --title "IPTABLES FIREWALL Rules" --menu "Choose an option" 15 65 8 \
        "a:" "Delete INPUT Rules" \
        "b:" "Delete OUTPUT Rules" \
        "c:" "DELETE FORWARD Rules" \
        "d:" "Go To Main Menu" 3>&1 1>&2 2>&3)
    if [[ $op == "a:" ]]; then
        displayINPUT
        command=$(whiptail --inputbox "Type in the rule number to delete" 8 78 --title "Input Rule #" 3>&1 1>&2 2>&3)
        status=$?
        if [[ $status = 1 ]]; then
            whiptail --title "Messsage box" --msgbox "No rule number provided " 20 78
        else
            whiptail --title "Messsage box" --msgbox "Rule # $command deleted from INPUT " 20 78
            sudo iptables -D INPUT $command
        fi 
        optionForDifferentRules

    elif [[ $op == "b:" ]]; then
        displayOUTPUT
        command=$(whiptail --inputbox "Type in the rule number to delete" 8 78 --title "Input Rule #" 3>&1 1>&2 2>&3)
        status=$?
        if [[ $status = 1 ]]; then
            whiptail --title "Messsage box" --msgbox "No rule number provided " 20 78
        else
            whiptail --title "Messsage box" --msgbox "Rule # $command deleted from OUPUT " 20 78
            sudo iptables -D OUTPUT $command
        fi
        optionForDifferentRules

    elif [[ $op == "c:" ]]; then
        displayFORWARD
        command=$(whiptail --inputbox "Type in the rule number to delete" 8 78 --title "Input Rule #" 3>&1 1>&2 2>&3)
        status=$?
        if [[ $status = 1 ]]; then
            whiptail --title "Messsage box" --msgbox "No rule number provided " 20 78
        else
            whiptail --title "Messsage box" --msgbox "Rule # $command deleted from OUPUT " 20 78
            sudo iptables -D FORWARD $command
        fi
        optionForDifferentRules

    else
        mainMenu
    fi
}

function optionForDifferentRules {
    response=$(whiptail --title "IPTABLES FIREWALL Rules" --menu "Choose an option" 15 65 8 \
        "a:" "Add Rules" \
        "b:" "Delete Rules" \
        "c:" "Go to Main Menu" 3>&1 1>&2 2>&3) 
    if [[ $response == "a:" ]]; then
        optionForAddingRules

    elif [[ $response == "b:" ]]; then
        optionForDeletingRules

    else
        mainMenu
    fi
}

function builtInFirewallOptions {
    options=$(whiptail --title "IPTABLES FIREWALL OPTIONS" --menu "Choose a firewall option" 15 65 8 \
        "a:" "Block ping from an ipaddress" \
        "b:" "Block any site EX: www.facebook.com" \
        "c:" "Block specific MAC Address" \
        "d:" "Block all TCP request" \
        "e:" "Block ssh connections" \
        "f:" "Block Outgoing SMTP mail" \
        "g:" "Go to Main Menu" 3>&1 1>&2 2>&3)
    
    if [[ $options == "a:" ]]; then
        ip=$(whiptail --inputbox "Type IPADDRESS to block to ping" 8 78 --title "IP Box" 3>&1 1>&2 2>&3)
        status=$? 
        if [[ $status = 1 ]]; then
            whiptail --title "Messsage box" --msgbox "No IPADDRESS provided!! " 20 78
        else
            whiptail --title "Messsage box" --msgbox "IPADDRESS $ip is blocked to ping!! " 20 78
            bashcommand=$(sudo iptables -A INPUT -s $ip -p icmp -j DROP)
        fi
        mainMenu
    
    elif [[ $options == "b:" ]]; then
        site=$(whiptail --inputbox "Type the URL of the site starting from WWW." 8 78 --title "URL Box" 3>&1 1>&2 2>&3)
        ip=$(host $site)
        whiptail --title "Copy the IP of the site" --msgbox "Copy the IP:\n $ip" 20 78
        input=$(whiptail --inputbox "Paste IPADDRESS of the site" 8 78 --title "IP Box" 3>&1 1>&2 2>&3)
        status=$?
        if [[ $status = 1 ]]; then
            whiptail --title "Messsage box" --msgbox "No IPADDRESS provided!! " 20 78
        else
            whiptail --title "Messsage box" --msgbox "IPADDRESS $input is blocked!! " 20 78
            bashcommand=$(sudo iptables -A OUTPUT -p tcp -d $input -j DROP)
        fi 
        mainMenu

    elif [[ $options == "c:" ]]; then
        input=$(whiptail --inputbox "Enter MAC address format=00:00:00:00:00:00" 8 78 --title "MAC Box" 3>&1 1>&2 2>&3)
        status=$?
        if [[ $status = 1 ]]; then
            whiptail --title "Messsage box" --msgbox "No MAC address provided!! " 20 78
        else
            whiptail --title "Messsage box" --msgbox "MAC address $input is blocked!! " 20 78
            bashcommand=$(sudo iptables -A INPUT -m mac --mac-source $input -j DROP)
        fi 
        mainMenu
    
    elif [[ $options == "d:" ]]; then
        input=$(whiptail --inputbox "Enter IP address" 8 78 --title "IP Box" 3>&1 1>&2 2>&3)
        status=$?
        if [[ $status = 1 ]]; then
            whiptail --title "Messsage box" --msgbox "No IPADDRESS provided!! " 20 78
        else
            whiptail --title "Messsage box" --msgbox "IP address $input is blocked from all TCP!! " 20 78
            bashcommand=$(sudo iptables -A INPUT -p tcp -s $input -j DROP)
        fi 
        mainMenu

    elif [[ $options == "e:" ]]; then
        input=$(whiptail --inputbox "Enter IP address" 8 78 --title "IP Box" 3>&1 1>&2 2>&3)
        status=$?
        if [[ $status = 1 ]]; then
            whiptail --title "Messsage box" --msgbox "No IPADDRESS provided!! " 20 78
        else
            whiptail --title "Messsage box" --msgbox "SSH connections blocked from $input!! " 20 78
            bashcommand=$(sudo iptables -A INPUT -p tcp --dport ssh -s $input -j DROP)
        fi 
        mainMenu

    elif [[ $options == "f:" ]]; then
        sudo iptables -A OUTPUT -p tcp --dport 25 -j REJECT
        whiptail --title "Messsage box" --msgbox "Port 25 is blocked for outgoing mail " 20 78
        mainMenu

    else
        mainMenu
    fi
}

mainMenu
