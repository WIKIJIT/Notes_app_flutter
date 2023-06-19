import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_quill/flutter_quill.dart';
import 'package:provider/provider.dart';

import 'models/note.dart';
import 'models/note_data.dart';

class EditingNotePage extends StatefulWidget {
  Note note;
  bool isNewNote;
  EditingNotePage({
    super.key,
    required this.note,
    required this.isNewNote,
  });

  @override
  State<EditingNotePage> createState() => _EditingNotePageState();
}

class _EditingNotePageState extends State<EditingNotePage> {
  QuillController _controller = QuillController.basic();

  @override
  void initState() {
    super.initState();
    loadExistingNote();
  }

  //load existing note
  void loadExistingNote() {
    final doc = Document()..insert(0, widget.note.text);
    setState(() {
      _controller = QuillController(
          document: doc, selection: const TextSelection.collapsed(offset: 0));
    });
  }

  //adding a new note
  void addNewNote() {
    //get new id
    int id = Provider.of<NoteData>(context, listen: false).getAllNotes().length;
    //get text from editor
    String text = _controller.document.toPlainText();
    //add the new note
    Provider.of<NoteData>(context, listen: false).addNewNote(
      Note(id: id, text: text),
    );
  }

  //updating an existing note
  void updateNote() {
    //get text from editor
    String text = _controller.document.toPlainText();
    //update note
    Provider.of<NoteData>(context, listen: false).updateNote(widget.note, text);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: CupertinoColors.systemGroupedBackground,
        appBar: AppBar(
          elevation: 0,
          backgroundColor: Colors.transparent,
          leading: IconButton(
            icon: const Icon(Icons.save_rounded),
            onPressed: () {
              //Is it a new note
              if (widget.isNewNote && !_controller.document.isEmpty()) {
                addNewNote();
              }

              //Is it an existing note
              else {
                updateNote();
              }

              Navigator.pop(context);
            },
            color: Colors.black,
          ),
        ),
        body: Column(
          children: [
            //toolbar
            QuillToolbar.basic(
              controller: _controller,
              // showAlignmentButtons: false,
              // showBackgroundColorButton: false,
              // showCenterAlignment: false,
              // showColorButton: false,
              // showCodeBlock: false,
              // showDirection: false,
              // showFontFamily: false,
              // showDividers: false,
              // showIndent: false,
              // showHeaderStyle: false,
              // showLink: false,
              // showSearchButton: false,
              // showInlineCode: false,
              // showQuote: false,
              // showListNumbers: false,
              // showListBullets: false,
              // showClearFormat: false,
              // showBoldButton: false,
              // showFontSize: false,
              // showItalicButton: false,
              // showUnderLineButton: false,
              // showStrikeThrough: false,
              // showListCheck: false,
              // showSubscript: false,
              // showSuperscript: false,
            ),
            //editor
            Expanded(
                child: Container(
              padding: const EdgeInsets.all(25.0),
              child:
                  QuillEditor.basic(controller: _controller, readOnly: false),
            ))
          ],
        ));
  }
}
