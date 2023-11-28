// routes.go

package main

import (
	"net/http"

	"github.com/gorilla/mux"
	"github.com/rs/cors"
)

func setupRoutes() http.Handler {
	r := mux.NewRouter()

	// Routes de l'API
	apiRouter := r.PathPrefix("/api").Subrouter()
	//NoteS
	apiRouter.HandleFunc("/notes", HandleGetNotes).Methods("GET")
	apiRouter.HandleFunc("/notes/{id}", HandleGetNote).Methods("GET")
	apiRouter.HandleFunc("/notes", HandleCreateNote).Methods("POST")
	apiRouter.HandleFunc("/notes/{id}", HandleUpdateNote).Methods("PUT")
	apiRouter.HandleFunc("/notes/{id}", HandleDeleteNote).Methods("DELETE")

	// // Configurer CORS
	// c := cors.Default()
	// apiHandler := c.Handler(apiRouter)

	// Configurer CORS avec des options personnalisées
	c := cors.New(cors.Options{
		AllowedOrigins: []string{"*"},
		AllowedMethods: []string{"GET", "POST", "PUT", "DELETE"},
	})
	apiHandler := c.Handler(apiRouter)

	// Retourne le routeur avec le middleware CORS ajouté
	return apiHandler
}
