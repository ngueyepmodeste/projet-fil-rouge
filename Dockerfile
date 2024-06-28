# Utilise l'image de base Python 3.6 Alpine
FROM python:3.6-alpine

# Définit le label du mainteneur et la version de l'image
LABEL mainteneur="modestengueyep1@gmail.com" version="1.0"

# Définit le répertoire de travail à /opt
WORKDIR /opt

#copy du code source de l'application vitrine dans le repertoire de travail opt/

COPY requirements.txt app.py  /opt/
COPY templates /opt/templates
COPY static /opt/static 
COPY images /opt/images

# Installe Flask via pip
RUN pip install -r requirements.txt

# Expose le port 8080 pour permettre l'accès à l'application
EXPOSE 8080

# Définit les variables d'environnement pour les URLs d'Odoo et de PgAdmin
ENV ODOO_URL=https://www.odoo.com
ENV PGADMIN_URL=https://www.pgadmin.org

# Définit le point d'entrée de l'application, en lançant app.py avec Python
ENTRYPOINT ["python", "./app.py"]

