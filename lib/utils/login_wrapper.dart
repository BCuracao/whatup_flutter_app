import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../src/screens/home_screen.dart';
import '../src/screens/registration_screen.dart';

class LoginWrapper extends StatefulWidget {
  const LoginWrapper({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _LoginWrapperState createState() => _LoginWrapperState();
}

class _LoginWrapperState extends State<LoginWrapper> {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<User?>(
      stream: _auth.authStateChanges(),
      builder: (BuildContext context, AsyncSnapshot<User?> snapshot) {
        if (snapshot.connectionState == ConnectionState.active) {
          final User? user = snapshot.data;
          if (user != null) {
            return const HomeScreen();
          } else {
            return const RegistrationScreen();
          }
        }
        return const CircularProgressIndicator();
      },
    );
  }
}
