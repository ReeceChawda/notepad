import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:intl/intl.dart';

import 'note.dart';

void main() async {
  await Hive.initFlutter();
  Hive.registerAdapter(NoteAdapter());
  runApp(const NoteApp());
}

class NoteApp extends StatelessWidget {
  const NoteApp({Key? key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
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
  late Box<Note> noteBox;
  List<Note> notes = [];
  TextEditingController noteInput = TextEditingController();
  TextEditingController titleInput = TextEditingController();

  void updateNoteList(Function(List<Note>) updateFunction) {
    setState(() {
      updateFunction(notes);
    });
  }

  @override
  void initState() {
    super.initState();
    openBox();
  }

  Future<void> openBox() async {
    noteBox = await Hive.openBox<Note>('notes');
    setState(() {
      notes = noteBox.values.toList();
    });
  }

// Main note
  void noteDialog() {
    showDialog(
      context: context,
      builder: (context) {
        return Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15.0),
            side:
                const BorderSide(color: Color.fromARGB(200, 0, 0, 0), width: 3),
          ),
          backgroundColor: const Color.fromARGB(255, 255, 252, 242),
          child: Container(
            width: 600,
            padding: const EdgeInsets.all(30.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                TextField(
                  controller: titleInput,
                  decoration: const InputDecoration(
                    focusedBorder: UnderlineInputBorder(
                      borderSide:
                          BorderSide(color: Color.fromARGB(255, 235, 60, 0)),
                    ),
                    hintText: "Title",
                    hintStyle:
                        TextStyle(color: Color.fromARGB(100, 64, 61, 57)),
                  ),
                  style: const TextStyle(
                      color: Color.fromARGB(255, 64, 61, 57),
                      fontWeight: FontWeight.w900,
                      fontSize: 20),
                ),
                TextField(
                  controller: noteInput,
                  decoration: const InputDecoration(
                    focusedBorder: UnderlineInputBorder(
                      borderSide:
                          BorderSide(color: Color.fromARGB(255, 235, 60, 0)),
                    ),
                    hintText: "Text",
                    hintStyle:
                        TextStyle(color: Color.fromARGB(100, 235, 60, 0)),
                  ),
                  style: const TextStyle(
                    color: Color.fromARGB(255, 235, 60, 0),
                    fontWeight: FontWeight.w200,
                  ),
                  maxLines: null,
                ),
                const SizedBox(height: 16),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    TextButton(
                      child: const Text(
                        "Cancel",
                        style:
                            TextStyle(color: Color.fromARGB(255, 235, 60, 0)),
                      ),
                      onPressed: () {
                        clearControllers();
                        Navigator.of(context).pop();
                      },
                    ),
                    TextButton(
                      child: const Text(
                        "Add",
                        style:
                            TextStyle(color: Color.fromARGB(255, 235, 60, 0)),
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

  // add / update notes
  void addNote() {
    String noteTitle = titleInput.text;
    String noteText = noteInput.text;
    DateTime currentDate = DateTime.now();

    if (noteTitle.isNotEmpty || noteText.isNotEmpty) {
      setState(() {
        noteBox
            .add(Note(noteTitle, noteText, date: currentDate)); // Pass the date
        notes = noteBox.values.toList();
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

//Edit note
    showDialog(
      context: context,
      builder: (context) {
        return Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15.0),
            side:
                const BorderSide(color: Color.fromARGB(200, 0, 0, 0), width: 3),
          ),
          backgroundColor: const Color.fromARGB(255, 255, 252, 242),
          child: Container(
            width: 600,
            padding: const EdgeInsets.all(30.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                TextField(
                  controller: editTitleController,
                  decoration: const InputDecoration(
                    focusedBorder: UnderlineInputBorder(
                      borderSide:
                          BorderSide(color: Color.fromARGB(255, 235, 60, 0)),
                    ),
                    hintText: "Title",
                    hintStyle:
                        TextStyle(color: Color.fromARGB(100, 64, 61, 57)),
                  ),
                  style: const TextStyle(
                    color: Color.fromARGB(255, 64, 61, 57),
                    fontWeight: FontWeight.w900,
                    fontSize: 20,
                  ),
                ),
                TextField(
                  controller: editNoteController,
                  decoration: const InputDecoration(
                      focusedBorder: UnderlineInputBorder(
                        borderSide:
                            BorderSide(color: Color.fromARGB(255, 235, 60, 0)),
                      ),
                      hintText: "Text",
                      hintStyle:
                          TextStyle(color: Color.fromARGB(100, 235, 60, 0))),
                  style: const TextStyle(
                      color: Color.fromARGB(255, 235, 60, 0),
                      fontWeight: FontWeight.w200),
                  maxLines: null,
                ),
                const SizedBox(height: 16),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    TextButton(
                      child: const Text(
                        "Cancel",
                        style:
                            TextStyle(color: Color.fromARGB(255, 235, 60, 0)),
                      ),
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                    ),
                    TextButton(
                      child: const Text(
                        "Save",
                        style:
                            TextStyle(color: Color.fromARGB(255, 235, 60, 0)),
                      ),
                      onPressed: () {
                        setState(() {
                          notes[index].title = editTitleController.text;
                          notes[index].text = editNoteController.text;
                          notes[index].date = DateTime.now();
                          noteBox.putAt(index, notes[index]);
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
    // notes.sort((a, b) {
    //   if (a.isPriority && !b.isPriority) {
    //     return -1;
    //   } else if (!a.isPriority && b.isPriority) {
    //     return 1;
    //   } else {
    //     return 0;
    //   }
    // });

//Main page
    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.fromLTRB(0, 0, 0, 0),
              child: Image.asset(
                'assets/astro_icon3.png',
                height: 38,
                width: 38,
              ),
            ),
            const Padding(
              padding: EdgeInsets.fromLTRB(10, 5, 0, 0),
              child: Text(
                "AstroNotes",
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.w400,
                  color: Color.fromARGB(255, 0, 0, 0),
                ),
              ),
            ),
          ],
        ),
        backgroundColor: const Color.fromARGB(255, 235, 60, 0),
        elevation: 5,
      ),
      backgroundColor: const Color.fromARGB(255, 64, 61, 57),
      body: notes.isEmpty
          ? const Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SizedBox(height: 20),
                  Flexible(
                    child: Text(
                      "Houston, we have a problem...\nNo notes yet!\n",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 20,
                        color: Color.fromARGB(250, 0, 0, 0),
                      ),
                    ),
                  ),
                  Opacity(
                    opacity: 0.6,
                    child: Image(
                      image: AssetImage('assets/astro.png'),
                      height: 300,
                      width: 300,
                    ),
                  ),
                ],
              ),
            )
          : ListView.builder(
              itemCount: notes.length,
              itemBuilder: (context, index) {
                return Card(
                  key: UniqueKey(),
                  elevation: 5,
                  margin: const EdgeInsets.fromLTRB(8, 8, 8, 0),
                  color: const Color.fromARGB(255, 255, 252, 242),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15.0),
                      side: const BorderSide(
                          color: Color.fromARGB(200, 0, 0, 0), width: 3)),
                  child: ListTile(
                    contentPadding: const EdgeInsets.fromLTRB(25, 5, 0, 10),
                    title: Padding(
                      padding: const EdgeInsets.fromLTRB(0, 5, 0, 5),
                      child: Text(
                        notes[index].title,
                        style: const TextStyle(
                            fontSize: 24,
                            color: Color.fromARGB(255, 64, 61, 57),
                            fontWeight: FontWeight.w900),
                      ),
                    ),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Padding(
                          padding: const EdgeInsets.fromLTRB(3, 0, 0, 0),
                          child: Text(
                            notes[index].text,
                            style: const TextStyle(
                                fontSize: 16,
                                color: Color.fromARGB(255, 235, 60, 0),
                                fontWeight: FontWeight.w200),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.fromLTRB(3, 10, 0, 0),
                          child: Text(
                            DateFormat('dd/MM\nH:mm a')
                                .format(notes[index].date.toLocal()),
                            style: const TextStyle(
                              fontSize: 12,
                              color: Color.fromARGB(255, 64, 61, 57),
                            ),
                          ),
                        ),
                      ],
                    ),
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        IconButton(
                          icon: notes[index].isPriority
                              ? const Icon(Icons.star,
                                  color: Color.fromARGB(255, 235, 60, 0))
                              : const Icon(Icons.star_border,
                                  color: Color.fromARGB(255, 64, 61, 57)),
                          padding: const EdgeInsets.fromLTRB(0, 3, 0, 0),
                          onPressed: () {
                            setState(() {
                              notes[index].isPriority =
                                  !notes[index].isPriority;
                              noteBox.putAt(index, notes[index]);
                            });
                          },
                        ),
                        IconButton(
                          icon: const Icon(Icons.edit,
                              color: Color.fromARGB(255, 235, 60, 0)),
                          padding: const EdgeInsets.fromLTRB(0, 3, 20, 0),
                          onPressed: () {
                            editNote(notes[index], index);
                          },
                        ),
                      ],
                    ),
                    onLongPress: () {
                      showDialog(
                        context: context,
                        builder: (context) {
                          return AlertDialog(
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(15.0),
                                side: const BorderSide(
                                    color: Color.fromARGB(255, 235, 60, 0))),
                            backgroundColor:
                                const Color.fromARGB(255, 255, 252, 242),
                            content: const Padding(
                              padding: EdgeInsets.fromLTRB(0, 25, 0, 0),
                              child: Text(
                                "Are you sure you want to delete this note?",
                                style: TextStyle(
                                  color: Color.fromARGB(255, 64, 61, 57),
                                  fontWeight: FontWeight.w500,
                                  fontSize: 18,
                                ),
                              ),
                            ),
                            actions: [
                              TextButton(
                                child: const Text(
                                  "Cancel",
                                  style: TextStyle(
                                      color: Color.fromARGB(255, 235, 60, 0)),
                                ),
                                onPressed: () {
                                  Navigator.of(context).pop();
                                },
                              ),
                              TextButton(
                                child: const Text(
                                  "Delete",
                                  style: TextStyle(
                                      color: Color.fromARGB(255, 235, 60, 0)),
                                ),
                                onPressed: () {
                                  setState(() {
                                    notes.removeAt(index);
                                    noteBox.deleteAt(index);
                                  });
                                  Navigator.of(context).pop();
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
            Tooltip(
              message: "Add Note",
              textStyle:
                  const TextStyle(color: Color.fromARGB(150, 235, 60, 0)),
              decoration: BoxDecoration(
                  color: const Color.fromARGB(200, 255, 252, 242),
                  borderRadius: BorderRadius.circular(8)),
              verticalOffset: 32,
              child:
                  buildFloatingActionButton(Icons.note_add_sharp, noteDialog),
            ),
            const SizedBox(width: 10),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    noteBox.close();
    super.dispose();
  }

//add button
  Widget buildFloatingActionButton(IconData icon, onPressed) {
    return FloatingActionButton(
      onPressed: onPressed,
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10.0),
          side: const BorderSide(
              color: Color.fromARGB(255, 64, 61, 57), width: 2)),
      elevation: 5,
      backgroundColor: const Color.fromARGB(200, 255, 252, 242),
      child: Icon(
        icon,
        color: const Color.fromARGB(255, 235, 60, 0),
      ),
    );
  }
}
