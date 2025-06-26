import 'dart:io';
import 'package:path/path.dart'; // لاستخراج اسم الملف من المسار
import 'package:firebase_storage/firebase_storage.dart'; // مكتبة Firebase Storage
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class ImageView extends StatefulWidget {
  const ImageView({super.key});

  @override
  State<ImageView> createState() => _ImageViewState();
}

class _ImageViewState extends State<ImageView> {
  File? imageFile;
  String? url;

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
      appBar: AppBar(
        title: const Text('Image View'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
      ),
      body: SizedBox(
        width: 100,
        height: 100,
        child: Column(
          children: [
            MaterialButton(
              color: Colors.blue,
              textColor: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
              onPressed: () async {
                await getImage();
              },
              child: const Text("Select Image"),
            ),
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
          ],
        ),
      ),
    );
  }
}
