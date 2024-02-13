# Utilisation d'une image Ubuntu (par défaut la dernière en date) pour construire notre image docker file
FROM ubuntu

# Mise à jour des repository distant du container, avant d'installer les paquets requis pour le projet
RUN apt update && apt upgrade -y

# Permet d'éviter d'avoir le bug concernant le choix de la timezone
RUN DEBIAN_FRONTEND="noninteractive" apt-get -y install tzdata

# Installation des paquets requis pour le projet à savoir git et le service web apache2
RUN apt-get install -y -q git apache2

# Le conteneur s'éxécutera en se basant sur le service apache2
ENTRYPOINT /usr/sbin/apache2ctl -D FOREGROUND

# Renommage du fichier de base d'apache2 index.html vers index.html.old
RUN mv /var/www/html/index.html /var/www/html/index.html.old

# Définir le répertoire de travail actuel
WORKDIR /var/www/html/

# Supprimer tous les fichiers du répertoire
RUN rm -rf *

# Récupération de mon repository Git avec le projet
RUN git clone https://github.com/stevenbachimont/siteweb

# Mettre à jour le référentiel Git avant de copier les fichiers
RUN cd siteweb && git pull origin master || true

# Copie des fichiers du mini projet web vers la racine de mon serveur web
RUN cd siteweb && cp -r * /var/www/html/
