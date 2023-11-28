# Utilise une image de base légère avec Go préinstallé
FROM golang:alpine

# Définit le répertoire de travail à l'intérieur du conteneur
WORKDIR /app

# Copie le fichier go.mod et go.sum pour installer les dépendances
COPY go.mod .
COPY go.sum .

# Installe les dépendances externes à l'aide de go get
RUN go mod download

# Copie le contenu actuel du répertoire de construction dans le conteneur
COPY . .

# Exécute la commande pour construire l'application Go
RUN go build -o main .

# Expose le port sur lequel l'application écoute
EXPOSE 8080

# Commande par défaut à exécuter lorsque le conteneur démarre
CMD ["./main"]
