<div align="center" id="top"> 
  <img src="./.github/app.gif" alt="Projet TO-DO EPSEED TEST" />

  &#xa0;

  <!-- <a href="https://projettodo{epseedtest}.netlify.app">Demo</a> -->
</div>

<h1 align="center">Projet TO-DO EPSEED TEST</h1>

<p align="center">
  <img alt="Github top language" src="https://img.shields.io/github/languages/top/IvanGael/projet-to-do-epseed-test?color=56BEB8">

  <img alt="Github language count" src="https://img.shields.io/github/languages/count/IvanGael/projet-to-do-epseed-test?color=56BEB8">

  <img alt="Repository size" src="https://img.shields.io/github/repo-size/IvanGael/projet-to-do-epseed-test?color=56BEB8">

  <img alt="License" src="https://img.shields.io/github/license/IvanGael/projet-to-do-{epseed-test}?color=56BEB8">


</p>


<p align="center">
  <a href="#dart-about">A propos</a> &#xa0; | &#xa0; 
  <a href="#rocket-technologies">Technologies</a> &#xa0; | &#xa0;
  <a href="#sparkles-features1">Fonctionnalités de l'API</a> &#xa0; | &#xa0;
  <a href="#sparkles-features2">Fonctionnalités de la web app</a> &#xa0; | &#xa0;
  <a href="#white_check_mark-requirements">Exigences</a> &#xa0; | &#xa0;
  <a href="#checkered_flag-starting">Pour lancer le projet</a> &#xa0; | &#xa0;
  <a href="https://github.com/IvanGael" target="_blank">Auteur</a>
</p>

<br>

## :dart: About ##

Il s'agit d'une petite application classique d'ajout de notes(ou de tâches). Le projet comporte une partie API(faite en Golang) et une partie web app(faite avec flutter)



## :rocket: Technologies ##

Les technologies utilisées sur ce projet:

- [Flutter](https://flutter.dev/)
- [Go](https://go.dev/)

## :sparkles: Features1 ##

:heavy_check_mark: Ajout/Modification/Suppression de notes;\

L'API se trouve dans le dossier todo_api du projet et comporte plusieurs fichiers.

- Un fichier main.go qui est le point d'entrée(le fichier principale) de l'API
- Un fichier .env qui contient différents variables d'environnement qui définissent les paramètres de connexion à la base de données postgresql `DB_USER=YOUR_DB_USER` `DB_PASSWORD=YOUR_DB_PASSWORD` `DB_HOST=localhost` `DB_PORT=5432` `DB_NAME=YOUR_DB_NAME`
- Un fichier db.go qui gère la connexion à la base de donnée postgresql
- Un fichier models.go qui contient les modèles de l'API
- Un fichier routes.go qui contient toutes les routes de l'API
- Un fichier note.services.go qui contient les fonctions qui gère l'action derrière chaque route(GET,POST,PUT, DELETE) de l'API
- Un fichier go.mod qui gère toutes les dépendances liés à l'API
- On a un DockerFile pour l'API

## Documentation de l'API 


#### Ajouter une note

```http
  GET http://localhost:8080/api/notes
```

| Paramètre | Type     | Description                       |
| :-------- | :------- | :-------------------------------- |
| `body`      | `json` | **Obligatoire**. les données à ajouter(Title, Content, Status...) |

#### Récupérer la liste des notes

```http
  GET http://localhost:8080/api/notes
```


#### Récupérer une note

```http
  GET http://localhost:8080/api/notes/${id}
```

| Paramètre | Type     | Description                       |
| :-------- | :------- | :-------------------------------- |
| `id`      | `string` | **Obligatoire**. l'Id de la note à récupérer |


#### Mettre à jour une note

```http
  PUT http://localhost:8080/api/notes/${id}
```

| Paramètre | Type     | Description                       |
| :-------- | :------- | :-------------------------------- |
| `id`      | `string` | **Obligatoire**. l'Id de la note à récupérer |
| `body`      | `json` | **Obligatoire**. Les données à mettre à jour(Title, Content, Status...) |



#### Supprimer une note

```http
  DELETE http://localhost:8080/api/notes/${id}
```

| Paramètre | Type     | Description                       |
| :-------- | :------- | :-------------------------------- |
| `id`      | `string` | **Obligatoire**. l'Id de la note à récupérer |


## :sparkles: Features2 ##

:heavy_check_mark: Ajout/Modification/Suppression de notes;\
:heavy_check_mark: Vue globale des notes en cours et effectuées;\

-La web app utilise une architecture modèle-view-viewmodel-services.
-Le dossier services contient une fichier noteService.dart qui contient des fonctions qui permettent de faire desrequêtes http vers l'API GO. Ensuite dans le dossier viewModels on a un fichier notesVieWModel.dart qui utilise NoteService pour récupérer les notes, ajouter une note, modifier ou supprimer une note. Dans le dossier views on les vues qui affichent les données. Ces vues utilisent à leur tour les viewModels.
- On a un DockerFile pour la web app


## :white_check_mark: Requirements ##

Avant de commencer :checkered_flag:, vous devez avoir [Flutter](https://flutter.dev/), [Go](https://go.dev/) et [Docker](https://www.docker.com/) installés sur votre système.

## :checkered_flag: Starting ##

```bash
# Cloner le project
$ git clone https://github.com/IvanGael/projet-to-do-epseed-test

# Accéder au dossier
$ cd projet-to-do-epseed-test

# Démarrer docker sur votre système

# Démarrer le projet avec docker
$ docker-compose up --build

# Trois conteneurs(l'api, le frontend et une base de données postgresq) seront crées

# Suffira donc de lancer la web app
```


<a href="#top">Retourner au début</a>
