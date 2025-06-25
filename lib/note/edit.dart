import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_course/components/textformfield.dart';
import 'package:firebase_course/note/view.dart';
import 'package:flutter/material.dart';

class EditNote extends StatefulWidget {
  final String noteId;
  final String categoryId;
  final String initialNoteText;

  const EditNote({
    super.key,
    required this.noteId,
    required this.categoryId,
    required this.initialNoteText,
  });

  @override
  State<EditNote> createState() => _EditNoteState();
}

class _EditNoteState extends State<EditNote> {
  GlobalKey<FormState> formKey = GlobalKey<FormState>();
  TextEditingController noteNameController = TextEditingController();

  Future<void> editNote() {
    final noteDoc = FirebaseFirestore.instance
        .collection('categories')
        .doc(widget.categoryId)
        .collection("note")
        .doc(widget.noteId);

    return noteDoc.update({'note': noteNameController.text});
  }

  @override
  void initState() {
    noteNameController.text = widget.initialNoteText;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Edit Note")),
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
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: () async {
                  if (formKey.currentState!.validate()) {
                    await editNote();
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text("Note edited successfully!"),
                      ),
                    );
                    Navigator.of(context).pushReplacement(
                      MaterialPageRoute(
                        builder:
                            (context) => ViewNote(noteId: widget.categoryId),
                      ),
                    );
                  }
                },
                child: const Text("Edit Note"),
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    noteNameController.dispose();
    super.dispose();
  }
}
