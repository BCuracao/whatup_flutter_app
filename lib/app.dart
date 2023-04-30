import 'package:flutter/material.dart';
import 'package:whatup/src/screens/home_screen.dart';
import 'package:whatup/utils/login_wrapper.dart';

class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Splash Screen Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const LoginWrapper(),
      routes: {
        '/home': (context) =>
            const HomeScreen(), // Replace with your home screen widget
      },
    );
  }
}
