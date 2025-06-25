import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_course/components/textformfield.dart';
import 'package:firebase_course/note/view.dart';
import 'package:flutter/material.dart';

class AddNote extends StatefulWidget {
  final String docId;
  const AddNote({super.key, required this.docId});

  @override
  State<AddNote> createState() => _AddNoteState();
}

class _AddNoteState extends State<AddNote> {
  GlobalKey<FormState> formKey = GlobalKey<FormState>();
  TextEditingController noteNameController = TextEditingController();

  Future<void> addNote() {
    final noteCollection = FirebaseFirestore.instance
        .collection('categories')
        .doc(widget.docId)
        .collection("note");

    return noteCollection.add({
      'note': noteNameController.text,
      /*its no necessary to add the id of the user here
          because the note is already associated with the category*/
      // "id": FirebaseAuth.instance.currentUser!.uid,
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Add Note")),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Form(
          key: formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              CustomTextForm(
                hinttext: "Enter Your Note",
                mycontroller: noteNameController,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return "Please enter Your Note";
                  }
                  return null;
                },
              ),
              SizedBox(height: 20),

              ElevatedButton(
                onPressed: () {
                  if (formKey.currentState!.validate()) {
                    // Handle the submission logic here
                    addNote();
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text("Note added successfully!")),
                    );
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (context) => ViewNote(noteId: widget.docId),
                      ),
                    );
                  }
                },
                child: Text("Add Category"),
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  dispose() {
    noteNameController.dispose();
    super.dispose();
  }
}
