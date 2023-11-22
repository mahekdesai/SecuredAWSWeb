#!/usr/bin/bash

#Function to install iptables
install_iptables() {
    echo "Installing iptables..."
    #Update existing packages
    sudo apt-get update
    sudo apt-get install -y iptables
}

#Function to install SNORT
install_snort() {
    echo "Installing Snort..."
    sudo apt-get install -y snort
}

#Function to install OpenSSH
install_openssh() {
    echo "Installing OpenSSH..."
    sudo apt-get install -y openssh-server
}

#Function to set ServerName directive in Apache configuration
set_apache_servername() {
    echo "Setting ServerName directive in Apache configuration..."
    echo "ServerName $1" | sudo tee -a /etc/apache2/apache2.conf
}

#Function to install and configure LAMP stack
install_configure_lamp() {
    echo "Installing LAMP stack..."

    #Installing APACHE
    sudo apt-get install -y apache2

    #Enable necessary Apache modules
    set_apache_servername "172.31.23.49"
    sudo systemctl enable apache2
    sudo systemctl restart apache2

    #Installing MySQL
    sudo apt-get install -y mysql-server 
    
    #Configure MySQL
    sudo mysql_secure_installation
 
    #Installing PHP
    sudo apt-get install -y php
    #Providing the PHP module for Apache
    sudo apt-get install -y libapache2-mod-php
    sudo apt-get install -y php-mysql

    #Enable the PHP module in Apache
    sudo a2enmod php
    sudo systemctl restart apache2

}


echo "Starting installation..."

#Install iptables
install_iptables

#Install Snort
install_snort

#Install OpenSSH
install_openssh

#Install and configure LAMP stack
install_configure_lamp

echo "Installation of iptables, Snort, OpenSSH and LAMP completed."

#sudo apache2ct1 -M | grep php
