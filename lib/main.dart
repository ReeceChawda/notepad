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
                    hintText: "Title",
                    hintStyle: TextStyle(color: Colors.grey),
                  ),
                  style: TextStyle(color: Colors.grey[300]),
                ),
                TextField(
                  controller: noteInput,
                  decoration: const InputDecoration(
                    hintText: "Note Text",
                    hintStyle: TextStyle(color: Colors.grey),
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
                    hintText: "Title",
                    hintStyle: TextStyle(color: Colors.grey),
                  ),
                  style: TextStyle(color: Colors.grey[300]),
                ),
                TextField(
                  controller: editNoteController,
                  decoration: const InputDecoration(
                      hintText: "Note Text",
                      hintStyle: TextStyle(color: Colors.grey)),
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
    //sorting system (star button)
    notes.sort((a, b) {
      if (a.isPriority && !b.isPriority) {
        return -1;
      } else if (!a.isPriority && b.isPriority) {
        return 1;
      } else {
        return 0;
      }
    });

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
                  margin: const EdgeInsets.fromLTRB(8, 8, 8, 0),
                  color: Colors.grey[800],
                  child: ListTile(
                    contentPadding: const EdgeInsets.fromLTRB(25, 5, 0 ,10),
                    title: Padding(
                      padding: const EdgeInsets.fromLTRB(0, 5, 0, 5),
                      child: Text(
                      notes[index].title,
                      style: const TextStyle(
                        fontSize: 20,
                        color: Colors.teal,
                      ),
                    ),
                    ),
                    subtitle: Text(
                      notes[index].text,
                      style: TextStyle(
                        fontSize: 16,
                        color: Colors.grey[300],
                      ),
                    ),
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        IconButton(
                          icon: notes[index].isPriority
                              ? const Icon(Icons.star, color: Colors.amber)
                              : const Icon(Icons.star_border),
                          onPressed: () {
                            setState(() {
                              notes[index].isPriority =
                                  !notes[index].isPriority;
                            });
                          },
                        ),
                        IconButton(
                          icon: const Icon(Icons.edit, color: Colors.teal),
                          onPressed: () {
                            editNote(notes[index], index);
                          },
                        ),
                      ],
                    ),
                    onLongPress: () {
                      // Show a confirmation dialog
                      showDialog(
                        context: context,
                        builder: (context) {
                          return AlertDialog(
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(15.0),
                            ),
                            backgroundColor: Colors.grey[900],
                            content: Padding(
                              padding: const EdgeInsets.fromLTRB(0, 25, 0, 0),
                              child: Text(
                                "Are you sure you want to delete this note?",
                                style: TextStyle(
                                  color: Colors.grey[300],
                                  fontSize: 18,
                                ),
                              ),
                            ),
                            actions: [
                              TextButton(
                                child: Text(
                                  "Cancel",
                                  style: TextStyle(color: Colors.teal),
                                ),
                                onPressed: () {
                                  Navigator.of(context).pop();
                                },
                              ),
                              TextButton(
                                child: Text(
                                  "Delete",
                                  style: TextStyle(color: Colors.teal),
                                ),
                                onPressed: () {
                                  // Delete the note
                                  setState(() {
                                    notes.removeAt(index);
                                  });
                                  Navigator.of(context)
                                      .pop(); // Close the dialog
                                },
                              ),
                            ],
                          );
                        },
                      );
                    },
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
