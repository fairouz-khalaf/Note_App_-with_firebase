import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_course/categories/edit.dart';
import 'package:firebase_course/note/add.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_sign_in/google_sign_in.dart';

class ViewNote extends StatefulWidget {
  final String noteId;
  const ViewNote({super.key, required this.noteId});

  @override
  State<ViewNote> createState() => _ViewNoteState();
}

List<QueryDocumentSnapshot> data = [];

class _ViewNoteState extends State<ViewNote> {
  getData() async {
    QuerySnapshot snapshot =
        await FirebaseFirestore.instance
            .collection("categories")
            .doc(widget.noteId)
            .collection("note")
            .get();
    data.addAll(snapshot.docs);
    setState(() {});
  }

  @override
  initState() {
    getData();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.orange,
        onPressed: () {
          Navigator.of(context).push(
            MaterialPageRoute(
              builder: (context) => AddNote(docId: widget.noteId),
            ),
          );
        },
        child: const Icon(Icons.add, color: Colors.white, size: 30),
      ),
      appBar: AppBar(
        title: const Text('Notes'),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () async {
              GoogleSignIn googleSignIn = GoogleSignIn();
              googleSignIn.disconnect();

              await FirebaseAuth.instance.signOut();
              Navigator.of(
                context,
              ).pushNamedAndRemoveUntil("login", (route) => false);
            },
          ),
        ],
      ),
      body: FutureBuilder<QuerySnapshot>(
        future:
            FirebaseFirestore.instance
                .collection("categories")
                .doc(widget.noteId)
                .collection("note")
                .get(),

        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return const Center(child: Text("No categories found"));
          }

          final data = snapshot.data!.docs;

          return GridView.builder(
            padding: const EdgeInsets.all(16),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              mainAxisExtent: 160,
              crossAxisSpacing: 16,
              mainAxisSpacing: 16,
            ),
            itemCount: data.length,
            itemBuilder: (context, index) {
              final category = data[index];
              return InkWell(
                onLongPress: () {
                  AwesomeDialog(
                    context: context,
                    dialogType: DialogType.info,
                    animType: AnimType.rightSlide,

                    desc: 'اختر ماذا تريد',
                    btnOkOnPress: () {
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder:
                              (context) => EditCategory(
                                categoryId: category['categoryName'].id,
                                categoryName: category['categoryName'],
                              ),
                        ),
                      );
                    },
                    btnCancelText: "حذف",
                    btnCancelOnPress: () async {
                      // await FirebaseFirestore.instance
                      //     .collection("categories")
                      //     .doc(category.id)
                      //     .delete();
                      // ScaffoldMessenger.of(context).showSnackBar(
                      //   const SnackBar(
                      //     content: Text("Category deleted successfully!"),
                      //   ),
                      // );
                    },
                  ).show();
                },
                child: Card(
                  elevation: 3,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        category['note'],
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
