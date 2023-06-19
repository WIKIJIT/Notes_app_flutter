import 'package:flutter/material.dart';
import 'package:notes/pages/models/data/hive_database.dart';
import 'note.dart';

class NoteData extends ChangeNotifier {
  //hive database
  final db = HiveDatabase();

  //overall list of notes
  List<Note> allNotes = [];

  //initialize the list
  void initializeNotes() {
    allNotes = db.loadNotes();
  }

  //get notes
  List<Note> getAllNotes() {
    return allNotes;
  }

  //add new note
  void addNewNote(Note note) {
    allNotes.add(note);
    db.savedNotes(allNotes);
    notifyListeners();
  }

  //update note
  void updateNote(Note note, String text) {
    //go through list of all notes
    for (int i = 0; i < allNotes.length; i++) {
      //find the relevant note
      if (allNotes[i].id == note.id) {
        allNotes[i].text = text;
      }
    }
    db.savedNotes(allNotes);
    notifyListeners();
  }

  //delete note
  void deleteNode(Note note) {
    allNotes.remove(note);
    db.savedNotes(allNotes);
    notifyListeners();
  }
}
