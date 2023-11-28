// note.services.go

package main

import (
	"encoding/json"
	"log"
	"net/http"

	"github.com/gorilla/mux"
)

// handleGetNote gère la requête GET pour récupérer une Note par ID
func HandleGetNote(w http.ResponseWriter, r *http.Request) {
	vars := mux.Vars(r)
	NoteID := vars["id"]

	var Note Note
	if err := db.First(&Note, "id = ?", NoteID).Error; err != nil {
		http.Error(w, "Note non trouvé", http.StatusNotFound)
		return
	}

	response, err := json.Marshal(Note)
	if err != nil {
		http.Error(w, "Erreur lors de la sérialisation de la Note", http.StatusInternalServerError)
		return
	}

	w.Header().Set("Content-Type", "application/json")
	w.Write(response)
}

// handleGetNotes gère la requête GET pour récupérer la liste des Notes
func HandleGetNotes(w http.ResponseWriter, r *http.Request) {
	var Notes []Note
	if err := db.Find(&Notes).Error; err != nil {
		http.Error(w, "Erreur lors de la récupération des Notes", http.StatusInternalServerError)
		return
	}

	response, err := json.Marshal(Notes)
	if err != nil {
		http.Error(w, "Erreur lors de la sérialisation des Notes", http.StatusInternalServerError)
		return
	}

	w.Header().Set("Content-Type", "application/json")
	w.Write(response)
}

// handleCreateNote gère la requête POST pour créer une Note
func HandleCreateNote(w http.ResponseWriter, r *http.Request) {
	var newNote Note
	err := json.NewDecoder(r.Body).Decode(&newNote)
	if err != nil {
		http.Error(w, "Erreur lors de la lecture des données de la Note", http.StatusBadRequest)
		return
	}

	if err := db.Create(&newNote).Error; err != nil {
		log.Println("Erreur lors de la création de la Note:", err)
		http.Error(w, "Erreur lors de la création de la Note", http.StatusInternalServerError)
		return
	}

	// Retourne une réponse JSON avec l'ID de la Note créée
	response := map[string]string{"id": newNote.ID, "title": newNote.Title}
	w.Header().Set("Content-Type", "application/json")
	w.WriteHeader(http.StatusCreated)
	json.NewEncoder(w).Encode(response)
}

// handleUpdateNote gère la requête PUT pour mettre à jour une Note par ID
func HandleUpdateNote(w http.ResponseWriter, r *http.Request) {
	vars := mux.Vars(r)
	NoteID := vars["id"]

	var existingNote Note

	// Vérifie si la Note avec l'ID spécifié existe
	if err := db.First(&existingNote, "id = ?", NoteID).Error; err != nil {
		http.Error(w, "Note non trouvée", http.StatusNotFound)
		return
	}

	var updatedNote Note
	err := json.NewDecoder(r.Body).Decode(&updatedNote)
	if err != nil {
		http.Error(w, "Erreur lors de la lecture des données de mise à jour de la Note", http.StatusBadRequest)
		return
	}

	// Mise à jour de la Note dans la base de données
	if err := db.Model(&Note{}).Where("id = ?", NoteID).Updates(updatedNote).Error; err != nil {
		http.Error(w, "Erreur lors de la mise à jour de la Note", http.StatusInternalServerError)
		return
	}

	w.Write([]byte("Note mis à jour avec succès. ID : " + NoteID))
}

// handleDeleteNote gère la requête DELETE pour supprimer un utilisateur par ID
func HandleDeleteNote(w http.ResponseWriter, r *http.Request) {
	vars := mux.Vars(r)
	NoteID := vars["id"]

	var existingNote Note

	// Vérifie si la Note avec l'ID spécifié existe
	if err := db.First(&existingNote, "id = ?", NoteID).Error; err != nil {
		http.Error(w, "Note non trouvée", http.StatusNotFound)
		return
	}

	// Suppression de la Note dans la base de données
	if err := db.Delete(&existingNote).Error; err != nil {
		http.Error(w, "Erreur lors de la suppression de la Note", http.StatusInternalServerError)
		return
	}

	w.Write([]byte("Note supprimée avec succès. ID : " + NoteID))
}
