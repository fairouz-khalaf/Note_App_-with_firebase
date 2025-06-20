import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_course/components/custombuttonauth.dart';
import 'package:firebase_course/components/textformfield.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';

class Login extends StatefulWidget {
  const Login({super.key});

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  TextEditingController email = TextEditingController();
  TextEditingController password = TextEditingController();
  GlobalKey<FormState> formState = GlobalKey<FormState>();

  Future signInWithGoogle() async {
    // Trigger the authentication flow
    final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();
    /*the following line will return null if the user cancels the sign-in to prevent not cause error if the user dont choose any email to sign in 
     the function will stope on return and wont display the remainig code*/
    if (googleUser == null) {
      // The user canceled the sign-in
      return;
    }

    // Obtain the auth details from the request
    final GoogleSignInAuthentication googleAuth =
        await googleUser.authentication;

    // Create a new credential
    final credential = GoogleAuthProvider.credential(
      accessToken: googleAuth.accessToken,
      idToken: googleAuth.idToken,
    );

    // Once signed in, return the UserCredential
    await FirebaseAuth.instance.signInWithCredential(credential);
    Navigator.of(context).pushNamedAndRemoveUntil("home", (route) => false);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        padding: const EdgeInsets.all(20),
        child: ListView(
          children: [
            Form(
              key: formState,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(height: 50),
                  // const CustomLogoAuth(),
                  Container(height: 20),
                  const Text(
                    "Login",
                    style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
                  ),
                  Container(height: 10),
                  const Text(
                    "Login To Continue Using The App",
                    style: TextStyle(color: Colors.grey),
                  ),
                  Container(height: 20),
                  const Text(
                    "Email",
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                  ),
                  Container(height: 10),
                  CustomTextForm(
                    validator:
                        (value) => value!.isEmpty ? "Email is required" : null,
                    hinttext: "ُEnter Your Email",
                    mycontroller: email,
                  ),
                  Container(height: 10),
                  const Text(
                    "Password",
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                  ),
                  Container(height: 10),
                  CustomTextForm(
                    validator:
                        (value) =>
                            value!.isEmpty ? "Password is required" : null,
                    hinttext: "ُEnter Your Password",
                    mycontroller: password,
                  ),
                  InkWell(
                    child: Container(
                      margin: const EdgeInsets.only(top: 10, bottom: 20),
                      alignment: Alignment.topRight,
                      child: const Text(
                        "Forgot Password ?",
                        style: TextStyle(fontSize: 14),
                      ),
                    ),
                    onTap: () async {
                      if (email.text.isEmpty) {
                        AwesomeDialog(
                          context: context,
                          dialogType: DialogType.error,
                          animType: AnimType.rightSlide,
                          title: 'خطأ',
                          desc: 'من فضلك أدخل البريد الإلكتروني',
                          btnOkOnPress: () {},
                        ).show();
                        return;
                      }

                      try {
                        final methods = await FirebaseAuth.instance
                            .fetchSignInMethodsForEmail(email.text.trim());

                        if (methods.isEmpty) {
                          AwesomeDialog(
                            context: context,
                            dialogType: DialogType.error,
                            animType: AnimType.rightSlide,
                            title: 'البريد غير مسجل',
                            desc:
                                'البريد الإلكتروني غير مسجل لدينا. تأكد من صحته أو أنشئ حسابًا جديدًا.',
                            btnOkOnPress: () {},
                          ).show();
                        } else {
                          await FirebaseAuth.instance.sendPasswordResetEmail(
                            email: email.text.trim(),
                          );

                          AwesomeDialog(
                            context: context,
                            dialogType: DialogType.info,
                            animType: AnimType.rightSlide,
                            title: 'تم الإرسال',
                            desc:
                                'إذا كان البريد الإلكتروني مسجلًا، ستتلقى رابط إعادة تعيين كلمة المرور.',
                            btnOkOnPress: () {},
                          ).show();
                        }
                      } catch (e) {
                        AwesomeDialog(
                          context: context,
                          dialogType: DialogType.error,
                          animType: AnimType.rightSlide,
                          title: 'حدث خطأ',
                          desc:
                              'حدث خطأ أثناء إرسال البريد. حاول مرة أخرى لاحقًا.',
                          btnOkOnPress: () {},
                        ).show();
                      }
                    },
                  ),
                ],
              ),
            ),
            CustomButtonAuth(
              title: "login",
              onPressed: () async {
                if (formState.currentState!.validate()) {
                  try {
                    final credential = await FirebaseAuth.instance
                        .signInWithEmailAndPassword(
                          email: email.text.trim(),
                          password: password.text.trim(),
                        );
                    if (credential.user!.emailVerified) {
                      Navigator.of(
                        context,
                      ).pushNamedAndRemoveUntil("home", (route) => false);
                    } else {
                      FirebaseAuth.instance.currentUser!
                          .sendEmailVerification();
                      AwesomeDialog(
                        context: context,
                        dialogType: DialogType.error,
                        animType: AnimType.rightSlide,
                        title: 'Error',
                        desc: 'Please verify your email before logging in',
                        btnCancelOnPress: () {},
                        btnOkOnPress: () {},
                      ).show();
                    }
                  } on FirebaseAuthException catch (e) {
                    if (e.code == 'user-not-found') {
                      AwesomeDialog(
                        context: context,
                        dialogType: DialogType.info,
                        animType: AnimType.rightSlide,

                        desc: 'No user found for that email',
                        btnCancelOnPress: () {},
                        btnOkOnPress: () {},
                      ).show();
                    } else if (e.code == 'wrong-password') {
                      AwesomeDialog(
                        context: context,
                        dialogType: DialogType.info,
                        animType: AnimType.rightSlide,
                        title: 'Dialog Title',
                        desc: 'Wrong password provided for that user',
                        btnCancelOnPress: () {},
                        btnOkOnPress: () {},
                      ).show();
                    }
                  }
                } else {
                  AwesomeDialog(
                    context: context,
                    dialogType: DialogType.error,
                    animType: AnimType.rightSlide,
                    title: 'Error',
                    desc: 'Please fill in all fields correctly',
                    btnCancelOnPress: () {},
                    btnOkOnPress: () {},
                  ).show();
                }
              },
            ),
            Container(height: 20),

            MaterialButton(
              height: 40,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),
              ),
              color: Colors.red[700],
              textColor: Colors.white,
              onPressed: () {
                signInWithGoogle();
              },
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text("Login With Google  "),
                  // Image.asset("images/4.png", width: 20),
                ],
              ),
            ),
            Container(height: 20),
            // Text("Don't Have An Account ? Resister" , textAlign: TextAlign.center,)
            InkWell(
              onTap: () {
                Navigator.of(context).pushNamed("signup");
              },
              child: const Center(
                child: Text.rich(
                  TextSpan(
                    children: [
                      TextSpan(text: "Don't Have An Account ? "),
                      TextSpan(
                        text: "Register",
                        style: TextStyle(
                          color: Colors.orange,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
