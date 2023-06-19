import 'package:hive/hive.dart';

import '../note.dart';

class HiveDatabase {
  //reference our hive box
  final _myBox = Hive.box('note_database');

  //load notes
  List<Note> loadNotes() {
    List<Note> savedNotesFormatted = [];

    //if there exists notes, return that, otherwise return empty List
    if (_myBox.get('ALL_NOTES') != null) {
      List<dynamic> savedNotes = _myBox.get("ALL_NOTES");
      for (int i = 0; i < savedNotes.length; i++) {
        //create individual note
        Note individualNote =
            Note(id: savedNotes[i][0], text: savedNotes[i][1]);
        //add to list
        savedNotesFormatted.add(individualNote);
      }
    } else {
      //default first note
      savedNotesFormatted.add(Note(id: 0, text: 'First Note'));
    }
    return savedNotesFormatted;
  }

  //save notes
  void savedNotes(List<Note> allNotes) {
    List<List<dynamic>> allNotesFormatted = [
      /*
      
      [0, "First Note"]
      [1, "Second Note"]
      ...

      */
    ];
    //each note has id and text
    for (var note in allNotes) {
      int id = note.id;
      String text = note.text;
      allNotesFormatted.add([id, text]);
    }
    //then store into hive
    _myBox.put("ALL_NOTES", allNotesFormatted);
  }
}
