// ignore_for_file: prefer_const_literals_to_create_immutables, prefer_const_constructors
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_course/auth/login.dart';
import 'package:firebase_course/auth/sign_up.dart';
import 'package:firebase_course/categories/add_category.dart';
import 'package:firebase_course/home_page.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
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
      },
    );
  }
}
