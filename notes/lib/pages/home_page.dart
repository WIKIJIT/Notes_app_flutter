import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'editing_note_page.dart';
import 'models/note_data.dart';
import 'models/note.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});
  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  void initState() {
    super.initState();
    Provider.of<NoteData>(context, listen: false).initializeNotes();
  }

  //create a new note

  void createNewNote() {
    int id = Provider.of<NoteData>(context, listen: false).getAllNotes().length;
    //create a blank note
    Note newNote = Note(
      id: id,
      text: '',
    );
    //go to edit the note
    goToNotePage(newNote, true);
  }

  //go to note editing page
  void goToNotePage(Note note, bool isNewNote) {
    Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => EditingNotePage(
            note: note,
            isNewNote: isNewNote,
          ),
        ));
  }

  //delete note
  void deleteNote(Note note) {
    Provider.of<NoteData>(context, listen: false).deleteNode(note);
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<NoteData>(
      builder: (context, value, child) => Scaffold(
        backgroundColor: CupertinoColors.systemGroupedBackground,
        //floatingActionButtonLocation: FloatingActionButtonLocation.miniEndTop,
        floatingActionButton: FloatingActionButton(
          onPressed: createNewNote,
          elevation: 50,
          backgroundColor: Colors.grey[300],
          child: const Icon(
            Icons.add,
            color: Colors.grey,
          ),
        ),
        body: SingleChildScrollView(
          padding: const EdgeInsets.only(bottom: 70),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              //heading
              const Padding(
                padding: EdgeInsets.only(left: 25.0, top: 75.0),
                child: Text(
                  'Notes',
                  style: TextStyle(fontSize: 32, fontWeight: FontWeight.bold),
                ),
              ),

              //list of notes
              value.getAllNotes().length == 0
                  ? Padding(
                      padding: const EdgeInsets.only(top: 50.0),
                      child: Center(
                        child: Text(
                          'Nothing Here...',
                          style: TextStyle(color: Colors.grey[400]),
                        ),
                      ))
                  : CupertinoListSection.insetGrouped(
                      children: List.generate(
                          value.getAllNotes().length,
                          (index) => CupertinoListTile(
                                title: Text(value.getAllNotes()[index].text),
                                onTap: () => goToNotePage(
                                    value.getAllNotes()[index], false),
                                trailing: IconButton(
                                  icon: Icon(Icons.delete),
                                  onPressed: () => showCupertinoDialog(
                                      context: context,
                                      builder: (BuildContext ctx) {
                                        return CupertinoAlertDialog(
                                          title: const Text('Please Confirm'),
                                          content: const Text(
                                              'Are you sure you want to Delete the note?'),
                                          actions: [
                                            // The "Yes" button
                                            CupertinoDialogAction(
                                              onPressed: () {
                                                setState(() {
                                                  //_isShown = false;
                                                  deleteNote(value
                                                      .getAllNotes()[index]);
                                                  Navigator.of(context).pop();
                                                });
                                              },
                                              isDefaultAction: true,
                                              isDestructiveAction: true,
                                              child: const Text('Yes'),
                                            ),
                                            // The "No" button
                                            CupertinoDialogAction(
                                              onPressed: () {
                                                Navigator.of(context).pop();
                                              },
                                              isDefaultAction: false,
                                              isDestructiveAction: false,
                                              child: const Text('No'),
                                            )
                                          ],
                                        );
                                      }),
                                  //deleteNote(value.getAllNotes()[index]),
                                ),
                              ))),
            ],
          ),
        ),
      ),
    );
  }
}
