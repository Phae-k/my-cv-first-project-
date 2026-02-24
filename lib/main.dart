// ignore_for_file: prefer_const_literals_to_create_immutables, prefer_const_constructors, non_constant_identifier_names, avoid_print, use_build_context_synchronously

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:project_01/application.dart';
import 'package:project_01/firebase_options.dart';
import 'page_signup.dart';

void main() async {
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  ).then((_) {
    print("Firebase connected.");
  });
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Login Page',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const SigninPage(title: 'Flutter Demo Home Page'),
    );
  }
}

class SigninPage extends StatefulWidget {
  const SigninPage({super.key, required this.title});
  final String title;

  @override
  State<SigninPage> createState() => _SigninPageState();
}

class _SigninPageState extends State<SigninPage> {
  TextEditingController controller_username = TextEditingController();
  TextEditingController controller_password = TextEditingController();

  bool is_password_visible = true;

  FirebaseFirestore db = FirebaseFirestore.instance;
  
  @override
  void initState() {
    super.initState();
    init();
  }

  void init() async {}

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(widget.title),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Row(
              children: [
                Spacer(),
                Text("Username: "),
                SizedBox(
                  width: 300,
                  child: TextField(
                    controller: controller_username,
                  ),
                ),
                SizedBox(width: 46),
                Spacer(),
              ],
            ),
            Row(
              children: [
                Spacer(),
                Text("Password: "),
                SizedBox(
                  width: 300,
                  child: TextField(
                    //
                    obscureText: is_password_visible, //
                    controller: controller_password,
                  ),
                ),
                IconButton(
                    onPressed: () {
                      //to show password
                      is_password_visible = !is_password_visible;
                      setState(() {});
                    },
                    // change icon based on visibility state
                    icon: !is_password_visible ? Icon(Icons.visibility) : Icon(Icons.visibility_off)),
                Spacer(),
              ],
            ),
            SizedBox(height: 20),
            Row(
              children: [
                Spacer(),
                OutlinedButton(
                    onPressed: () async {
                      
                      String username = controller_username.text;
                      print(username);
                      String password = controller_password.text;
                      print(password);

                      await db //
                          .collection("collection_credential")
                          .where("username", isEqualTo: username)
                          .where("password", isEqualTo: password)
                          .get()
                          .then((q) {
                        if (q.docs.isEmpty) {
                          print("Sign In failed.");
                        } else {
                          Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context) {
                            return ApplicationPage(title: "");

                            // Navigator.of(context).push(
                            //     MaterialPageRoute(builder: (context) {
                            //   return SignupPage(title: "");
                            // }
                          }));
                          print("Sign In successful.");
                        }
                      });
                    },
                    child: Text("Sign In")),
                SizedBox(width: 20),
                OutlinedButton(
                    onPressed: () {
                      // Pushreplacement to Signup Page cannot go back to Signin Page
                      // Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context) {
                      //   return SignupPage(title: "");
                      // }));

                      // Push to Signup Page can go back to Signin Page
                      Navigator.of(context).push(MaterialPageRoute(builder: (context) {
                        return SignupPage(title: "");
                      }));
                    },
                    child: Text("Sign UP")),
                Spacer(),
              ],
            )
          ],
        ),
      ),
    );
  }
}