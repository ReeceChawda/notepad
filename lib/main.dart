import 'package:flutter/material.dart';
import 'package:notepad/note.dart';

void main() => runApp(const NoteApp());

class NoteApp extends StatelessWidget {
  const NoteApp({Key? key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      home: NotePadApp(),
    );
  }
}

class NotePadApp extends StatefulWidget {
  const NotePadApp({Key? key});

  @override
  NotePadAppState createState() => NotePadAppState();
}

class NotePadAppState extends State<NotePadApp> {
  List<Note> notes = [];
  TextEditingController noteInput = TextEditingController();
  TextEditingController titleInput = TextEditingController();

  void noteBox() {
    showDialog(
      context: context,
      builder: (context) {
        return Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15.0),
          ),
          backgroundColor: Colors.grey[900], // Dark background color
          child: Container(
            width: 600, // Adjust the width as per your preference
            padding: const EdgeInsets.all(30.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                TextField(
                  controller: titleInput,
                  decoration: const InputDecoration(
                    labelText: "Title",
                    labelStyle: TextStyle(color: Colors.grey),
                  ),
                  style: TextStyle(color: Colors.grey[300]),
                ),
                TextField(
                  controller: noteInput,
                  decoration: const InputDecoration(
                    labelText: "Note Text",
                    labelStyle: TextStyle(color: Colors.grey),
                  ),
                  style: TextStyle(color: Colors.grey[300]),
                  maxLines: null,
                ),
                const SizedBox(height: 16),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    TextButton(
                      child: const Text(
                        "Cancel",
                        style: TextStyle(color: Colors.teal),
                      ),
                      onPressed: () {
                        clearControllers();
                        Navigator.of(context).pop();
                      },
                    ),
                    TextButton(
                      child: const Text(
                        "Add",
                        style: TextStyle(color: Colors.teal),
                      ),
                      onPressed: () {
                        addNote();
                        Navigator.of(context).pop();
                      },
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  void addNote() {
    String noteTitle = titleInput.text;
    String noteText = noteInput.text;
    if (noteTitle.isNotEmpty || noteText.isNotEmpty) {
      setState(() {
        notes.add(Note(noteTitle, noteText));
        clearControllers();
      });
    }
  }

  void clearControllers() {
    titleInput.clear();
    noteInput.clear();
  }

  void deleteNotes() {
    setState(() {
      notes.removeWhere((note) => note.isDone);
    });
  }

  void editNote(Note note, int index) {
    TextEditingController editTitleController =
        TextEditingController(text: note.title);
    TextEditingController editNoteController =
        TextEditingController(text: note.text);

    showDialog(
      context: context,
      builder: (context) {
        return Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15.0),
          ),
          backgroundColor: Colors.grey[900],
          child: Container(
            width: 400,
            padding: const EdgeInsets.all(16.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                TextField(
                  controller: editTitleController,
                  decoration: const InputDecoration(
                    labelText: "Title",
                    labelStyle: TextStyle(color: Colors.grey),
                  ),
                  style: TextStyle(color: Colors.grey[300]),
                ),
                TextField(
                  controller: editNoteController,
                  decoration: const InputDecoration(
                      labelText: "Note Text",
                      labelStyle: TextStyle(color: Colors.grey)),
                  style: TextStyle(color: Colors.grey[300]),
                  maxLines: null,
                ),
                const SizedBox(height: 16),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    TextButton(
                      child: const Text(
                        "Cancel",
                        style: TextStyle(color: Colors.teal),
                      ),
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                    ),
                    TextButton(
                      child: const Text(
                        "Save",
                        style: TextStyle(color: Colors.teal),
                      ),
                      onPressed: () {
                        setState(() {
                          notes[index].title = editTitleController.text;
                          notes[index].text = editNoteController.text;
                        });
                        Navigator.of(context).pop();
                      },
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Row(
          children: <Widget>[
            Icon(Icons.folder, color: Colors.teal),
            SizedBox(width: 10),
            Text("Notes",
                style: TextStyle(
                  fontSize: 30,
                  color: Colors.teal,
                )),
          ],
        ),
        backgroundColor: Colors.grey[850],
        elevation: 5,
      ),
      backgroundColor: Colors.grey[900],
      body: notes.isEmpty
          ? Center(
              child: Text(
                "No notes yet.",
                style: TextStyle(
                  fontSize: 30,
                  color: Colors.grey[800],
                ),
              ),
            )
          : ListView.builder(
              itemCount: notes.length,
              itemBuilder: (context, index) {
                return Card(
                  elevation: 5,
                  margin: const EdgeInsets.all(10),
                  color: Colors.grey[800],
                  child: ListTile(
                    selected: notes[index].isDone,
                    onTap: () {
                      setState(() {
                        notes[index].isDone = !notes[index].isDone;
                      });
                    },
                    leading: Checkbox(
                      value: notes[index].isDone,
                      onChanged: null,
                    ),
                    title: Text(
                      notes[index].title,
                      style: const TextStyle(
                        fontSize: 20,
                        color: Colors.teal,
                      ),
                    ),
                    subtitle: Text(
                      notes[index].text,
                      style: TextStyle(
                        fontSize: 16,
                        color: Colors.grey[300],
                      ),
                    ),
                    trailing: IconButton(
                      icon: const Icon(Icons.edit, color: Colors.teal),
                      onPressed: () {
                        editNote(notes[index], index);
                      },
                    ),
                  ),
                );
              },
            ),
      floatingActionButton: Align(
        alignment: Alignment.bottomRight,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            buildFloatingActionButton(Icons.note_add_sharp, noteBox),
            const SizedBox(width: 10),
            buildFloatingActionButton(Icons.delete_sharp, deleteNotes),
          ],
        ),
      ),
    );
  }

  Widget buildFloatingActionButton(IconData icon, onPressed) {
    return FloatingActionButton(
      onPressed: onPressed,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10.0),
      ),
      elevation: 5,
      backgroundColor: Colors.grey[850],
      child: Icon(
        icon,
        color: Colors.teal,
      ),
    );
  }
}