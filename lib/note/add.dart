import 'dart:io';
import 'package:path/path.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_course/components/textformfield.dart';
import 'package:firebase_course/note/view.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class AddNote extends StatefulWidget {
  final String docId;

  const AddNote({super.key, required this.docId});

  @override
  State<AddNote> createState() => _AddNoteState();
}

class _AddNoteState extends State<AddNote> {
  GlobalKey<FormState> formKey = GlobalKey<FormState>();
  TextEditingController noteNameController = TextEditingController();
  File? imageFile;
  String? url;

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

  getImage() async {
    final ImagePicker picker = ImagePicker();

    // اختيار صورة من المعرض
    final XFile? image = await picker.pickImage(source: ImageSource.gallery);

    // التأكد إن فيه صورة فعلاً
    if (image == null) return;

    // تحويل XFile إلى File
    imageFile = File(image.path);

    // استخراج اسم الملف من المسار
    var imageName = basename(image.path);

    // 🔥 إنشاء مرجع داخل Firebase Storage بمسار (مثلاً uploads/photo.jpg)
    var refStorage = FirebaseStorage.instance.ref("uploads/$imageName");
    // او
    // var refStorage = FirebaseStorage.instance.ref("uploads").child(imageName);

    // 🔼 رفع الملف إلى Firebase Storage
    await refStorage.putFile(imageFile!);

    // 🌐 الحصول على رابط التحميل النهائي للصورة بعد رفعها
    url = await refStorage.getDownloadURL();

    // تحديث الواجهة لعرض الصورة
    setState(() {});
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
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.orange,
                  padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                ),
                onPressed: () async {
                  await getImage();
                  if (imageFile != null) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text("Image selected successfully!")),
                    );
                  } else {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text("No image selected")),
                    );
                  }
                },
                child: Text("Add Image"),
              ),
              SizedBox(height: 20),
              if (imageFile != null)
                Center(
                  // عرض الصورة اللي تم رفعها عن طريق رابطها من Firebase Storage
                  child: Image.network(
                    url!,
                    height: 100,
                    width: 100,
                    fit: BoxFit.cover,
                  ),
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
                child: Text("Add Note"),
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
