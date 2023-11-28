// ignore_for_file: file_names

import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:todo_web_app/models/note.dart';

class NoteService {
  final String apiUrl = 'http://localhost:8080/api/notes';

  Future<List<Note>> getNotes() async {
    try {
      final response = await http.get(Uri.parse(apiUrl));

      if (response.statusCode == 200) {
        print('response.body : ${response.body}');
        List<dynamic> data = json.decode(response.body);
        List<Note> notes = data.map((note) => Note.fromJson(note)).toList();
        return notes;
      } else {
        throw Exception('Échec de la récupération des notess');
      }
    } catch (error) {
      throw Exception('Erreur inattendue: $error');
    }
  }

  Future<void> addNote(Note newNote) async {
    try {
      final response = await http.post(
        Uri.parse(apiUrl),
        headers: {'Content-Type': 'application/json'},
        body: json.encode(newNote.toJson()),
      );

      if (response.statusCode == 201) {
        // La note a été ajoutée avec succès
        print("Note ${newNote.title} ajoutée avec succès");
      } else {
        throw Exception('Échec de l\'ajout de la note');
      }
    } catch (error) {
      throw Exception('Erreur inattendue: $error');
    }
  }

  Future<void> updateNote(Note updatedNote) async {
    try {
      final response = await http.put(
        Uri.parse('$apiUrl/${updatedNote.id}'),
        headers: {'Content-Type': 'application/json'},
        body: json.encode(updatedNote.toJson()),
      );

      if (response.statusCode == 200) {
        // La note a été mise à jour avec succès
        print("Note ${updatedNote.title} mise à jour avec succès");
      } else {
        throw Exception('Échec de la mise à jour de la note');
      }
    } catch (error) {
      throw Exception('Erreur inattendue: $error');
    }
  }

  Future<void> deleteNote(String noteId) async {
    try {
      final response = await http.delete(
        Uri.parse('$apiUrl/$noteId'),
      );

      if (response.statusCode == 204) {
        // La note a été supprimée avec succès
        print("Note supprimée avec succès");
      } else {
        throw Exception('Échec de la suppression de la note');
      }
    } catch (error) {
      throw Exception('Erreur inattendue: $error');
    }
  }
}
