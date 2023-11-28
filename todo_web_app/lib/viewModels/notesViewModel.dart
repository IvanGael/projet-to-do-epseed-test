// ignore_for_file: file_names


import 'package:flutter/material.dart';
import 'package:todo_web_app/models/note.dart';
import 'package:todo_web_app/services/noteService.dart';

class NotesViewModel extends ChangeNotifier{
  final NoteService _noteService = NoteService();
  List<Note> notes = [];
  List<Note> activeNotes = [];
  List<Note> completedNotes = [];

  void fetchNotes () async{
    notes = await _noteService.getNotes();
    notifyListeners();
  }

  void fetchActiveAndCompletedNotes () async {
    fetchNotes ();
    activeNotes = notes.where((element) => element.status == "Active").toList();
    completedNotes = notes.where((element) => element.status != "Active").toList();
  }


  void addNewNote(Note newNote) {
    _noteService.addNote(newNote);
    fetchNotes(); // Met à jour la liste des nôtes après l'ajout
  }

  void updateNote(Note updatedNote){
    _noteService.updateNote(updatedNote);
    fetchNotes(); // Met à jour la liste des nôtes après la mise à jour
  }

  void deleteNote(Note note){
    _noteService.deleteNote(note.id!);
    fetchNotes(); // Met à jour la liste des nôtes après la suppression
  }
}