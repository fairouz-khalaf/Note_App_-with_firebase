import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_course/components/textformfield.dart';
import 'package:flutter/material.dart';

class EditCategory extends StatefulWidget {
  final String categoryId;
  final String categoryName;
  const EditCategory({
    super.key,
    required this.categoryId,
    required this.categoryName,
  });

  @override
  State<EditCategory> createState() => _EditCategoryState();
}

class _EditCategoryState extends State<EditCategory> {
  GlobalKey<FormState> formKey = GlobalKey<FormState>();
  TextEditingController categoryNameController = TextEditingController();
  CollectionReference categories = FirebaseFirestore.instance.collection(
    'categories',
  );

  Future<void> editCategory() {
    return categories
        .doc(widget.categoryId)
        .update({
          'categoryName': categoryNameController.text,
          "id": FirebaseAuth.instance.currentUser!.uid,
        })
        .then((value) => print("Category Updated"))
        .catchError((error) => print("Failed to update category: $error"));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Edit Category")),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Form(
          key: formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              CustomTextForm(
                hinttext: "Category Name",
                mycontroller: categoryNameController,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return "Please enter a category name";
                  }
                  return null;
                },
              ),
              SizedBox(height: 20),

              SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  if (formKey.currentState!.validate()) {
                    // Handle the submission logic here
                    editCategory();
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text("Category updated successfully!")),
                    );
                    Navigator.pop(context);
                  }
                },
                child: Text("Edit Category"),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
