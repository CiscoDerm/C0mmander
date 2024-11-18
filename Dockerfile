# Étape 1 : Image de base Kali Linux
FROM kali:latest

# Étape 2 : Mise à jour et installation des outils essentiels
RUN apt update && apt upgrade -y && \
    apt install -y \
    nmap metasploit-framework burpsuite john hydra sqlmap wfuzz gobuster nikto \
    aircrack-ng reaver msfvenom beefproject empire \
    docker-compose portainer xfce4 xfce4-terminal tightvncserver supervisor \
    openvpn proxychains4 tigervnc-viewer \
    curl wget git tmux lxqt

# Étape 3 : Installation de Python et autres outils Python
RUN pip3 install pwntools impacket mitmproxy

# Étape 4 : Clonage des repositories pour des outils supplémentaires
WORKDIR /tools
RUN git clone https://github.com/carlospolop/PEASS-ng.git && \
    git clone https://github.com/danielmiessler/SecLists.git

# Étape 5 : Configuration du serveur VNC et gestionnaire de sessions
COPY config/supervisord.conf /etc/supervisor/conf.d/supervisord.conf
RUN echo "pentest" | vncpasswd -f > /root/.vnc/passwd && chmod 600 /root/.vnc/passwd

# Étape 6 : Création d'un utilisateur non-root
RUN useradd -ms /bin/bash pentest
USER pentest
WORKDIR /home/pentest

# Étape 7 : Commande d’entrée par défaut
CMD ["/usr/bin/supervisord"]
