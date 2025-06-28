// ignore_for_file: prefer_const_literals_to_create_immutables, prefer_const_constructors
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_course/auth/login.dart';
import 'package:firebase_course/auth/sign_up.dart';
import 'package:firebase_course/categories/add_category.dart';
import 'package:firebase_course/chat.dart';
import 'package:firebase_course/home_page.dart';
import 'package:firebase_course/note/image.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';

Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  print("Handling a background message: ${message.messageId}");
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);

  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  void initState() {
    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
      if (message.data['type'] == "chat") {
        Navigator.of(context).push(
          MaterialPageRoute(
            builder:
                (context) => Chat(), // Replace with your chat screen widget
          ),
        );
      }
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        appBarTheme: AppBarTheme(
          backgroundColor: Colors.grey,
          titleTextStyle: TextStyle(
            color: Colors.orange,
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),

        scaffoldBackgroundColor: Colors.white,
        textTheme: TextTheme(
          bodyLarge: TextStyle(color: Colors.black, fontSize: 16),
          bodyMedium: TextStyle(color: Colors.black54, fontSize: 14),
        ),
      ),
      debugShowCheckedModeBanner: false,
      home:
          FirebaseAuth.instance.currentUser != null
              // &&
              //         FirebaseAuth.instance.currentUser!.emailVerified
              ? Homepage()
              : Login(),

      routes: {
        "signup": (context) => SignUp(),
        "login": (context) => Login(),
        "homePage": (context) => Homepage(),
        "addCategory": (context) => AddCategory(),
        "imageView": (context) => ImageView(),
      },
    );
  }
}
