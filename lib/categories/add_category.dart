import 'package:firebase_course/components/textformfield.dart';
import 'package:flutter/material.dart';

class AddCategory extends StatefulWidget {
  const AddCategory({super.key});

  @override
  State<AddCategory> createState() => _AddCategoryState();
}

class _AddCategoryState extends State<AddCategory> {
  GlobalKey<FormState> formKey = GlobalKey<FormState>();
  TextEditingController categoryNameController = TextEditingController();
  TextEditingController categoryDescriptionController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Add Category")),
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
              CustomTextForm(
                hinttext: "Category Description",
                mycontroller: categoryDescriptionController,

                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return "Please enter a category description";
                  }
                  return null;
                },
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  if (formKey.currentState!.validate()) {
                    // Handle the submission logic here
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text("Category added successfully!")),
                    );
                    Navigator.pop(context);
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
}
