import 'package:fabrica_de_biscoitos/main.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../models/line.dart';
import '../models/oven.dart';
import 'home_page.dart';

class LoginPage extends StatefulWidget {
  @override
  final LineA lineA;
  final LineB lineB;
  final LineC lineC;
  final Oven oven1;
  final Oven oven2;

  const LoginPage({
    super.key,
    required this.lineA,
    required this.lineB,
    required this.lineC,
    required this.oven1,
    required this.oven2,
  });
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  String email = '';
  String password = '';

  Future<void> _signInWithEmailAndPassword() async {
    try {
      UserCredential userCredential = await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      User? user = userCredential.user;
      // Navigate to the home page after successful login
      // ignore: use_build_context_synchronously
      Navigator.pushReplacement(
          context,
          MaterialPageRoute(
              builder: (context) => MyApp(
                    lineA: widget.lineA,
                    lineB: widget.lineB,
                    lineC: widget.lineC,
                    oven1: widget.oven1,
                    oven2: widget.oven2,
                    userCredential: user!,
                  )));
    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found') {
        print('No user found for that email.');
      } else if (e.code == 'wrong-password') {
        print('Wrong password provided for that user.');
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Login Page'),
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            TextField(
              onChanged: (value) {
                email = value;
              },
              decoration: InputDecoration(hintText: 'Enter your email'),
            ),
            SizedBox(height: 8.0),
            TextField(
              obscureText: true,
              onChanged: (value) {
                password = value;
              },
              decoration: InputDecoration(hintText: 'Enter your password'),
            ),
            SizedBox(height: 24.0),
            ElevatedButton(
              onPressed: _signInWithEmailAndPassword,
              child: Text('Login'),
            ),
          ],
        ),
      ),
    );
  }

  void isLogged() {
    User? currentUser = _auth.currentUser;

    if (currentUser != null) {
      Navigator.pushReplacement(
          context,
          MaterialPageRoute(
              builder: (context) => MyApp(
                    lineA: widget.lineA,
                    lineB: widget.lineB,
                    lineC: widget.lineC,
                    oven1: widget.oven1,
                    oven2: widget.oven2,
                    userCredential: currentUser,
                  )));
    }
  }
}
