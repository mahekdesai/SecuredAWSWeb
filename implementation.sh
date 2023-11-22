#!/usr/bin/bash

#Function to set up iptables rules
setup_iptables() {
    echo "Setting up iptables rules..."

    #Flush existing rules and set default policies
    sudo iptables -F

    #Default policy for the INPUT chain to DROP
    sudo iptables -P INPUT DROP

    #Default policy for the FORWARD chain to DROP
    sudo iptables -P FORWARD DROP

    #default policy for the OUTPUT chain to ACCEPT
    sudo iptables -P OUTPUT ACCEPT

    #Allow loopback interface
    sudo iptables -A INPUT -i lo -j ACCEPT

    #Allow SSH traffic from new and established connections
    sudo iptables -A INPUT -p tcp --dport 22 -m state --state NEW,ESTABLISHED -j ACCEPT

    #Allow HTTP traffic from new and established connections
    sudo iptables -A INPUT -p tcp --dport 80 -m state --state NEW,ESTABLISHED -j ACCEPT

    #Allow HTTPS traffic from new and established connections
    sudo iptables -A INPUT -p tcp --dport 443 -m state --state NEW,ESTABLISHED -j ACCEPT

    #Allow established and related connections
    sudo iptables -A INPUT -m state --state ESTABLISHED,RELATED -j ACCEPT

    #Drop all other incoming traffic
    sudo iptables -A INPUT -j DROP
}

#Function to set up Snort rules
setup_snort_rules() {
    echo "Setting up SNORT rules..."

    #Set HOME_NET value as server's private IP 
    HOME_NET="172.31.23.49/16"

    #any network other than HOME_NET is EXTERNAL_NET 
    EXTERNAL_NET="!$HOME_NET"

    SNORT_RULES_PATH="/etc/snort/rules"
    LOCAL_RULES_FILE="$SNORT_RULES_PATH/local.rules"

    #Create a local rules file if not exists 
    sudo touch $LOCAL_RULES_FILE

    #Define your custom Snort rules
    CUSTOM_RULE1="alert tcp any any -> $HOME_NET 80 (msg:\"HTTP Traffic\"; sig_d:1000001; rev: 1)"
    CUSTOM_RULE2="alert udp any any -> $HOME_NET 21 (msg:\"FTP Traffic\"; sig_d: 1000002; rev: 1)"

    #Append the rules to snort.conf
    sudo bash -c "echo \"$CUSTOM_RULE1\" >> /etc/snort/snort.conf"
    sudo bash -c "echo \"$CUSTOM_RULE2\" >> /etc/snort/snort.conf"

    #Restart Snort to apply the changes
    sudo service snort restart
}

#Main script
echo "Starting security policy setup..."

#Set up iptables rules
setup_iptables

#Set up Snort rules
setup_snort_rules

echo "Security policy setup completed."