# Stage 1
FROM debian:latest AS build-env

RUN apt-get update 
RUN apt-get install -y curl git wget unzip libgconf-2-4 gdb libstdc++6 libglu1-mesa fonts-droid-fallback lib32stdc++6 python3
RUN apt-get clean

RUN git clone https://github.com/flutter/flutter.git /usr/local/flutter

ENV PATH="/usr/local/flutter/bin:/usr/local/flutter/bin/cache/dart-sdk/bin:${PATH}"

RUN flutter doctor -v

RUN flutter channel master
RUN flutter upgrade
RUN flutter config --enable-web

RUN mkdir /app/
COPY . /app/
WORKDIR /app/
RUN flutter build web

# Expose le port sur lequel l'application web sera servie
EXPOSE 80

# Stage 2
FROM nginx:1.21.1-alpine
COPY --from=build-env /app/build/web /usr/share/nginx/html



# # Utilise l'image officielle de Flutter comme base
# FROM mobiledevops/flutter-sdk-image:3.7.7

# # Définit le répertoire de travail à l'intérieur du conteneur
# WORKDIR /app

# # Copie les fichiers nécessaires pour le build
# COPY . .

# # Installe les dépendances
# RUN flutter pub get

# # Installe les outils de développement web
# RUN flutter config --enable-web
# RUN flutter pub global activate webdev

# # Construit l'application pour le web
# RUN flutter build web

# # Expose le port sur lequel l'application web sera servie
# EXPOSE 80

# # Commande par défaut à exécuter lorsque le conteneur démarre
# CMD ["flutter", "run", "-d", "web"]
