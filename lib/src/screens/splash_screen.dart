import 'dart:async';
import 'package:flutter/material.dart';
import 'package:whatup/src/screens/registration_screen.dart';

import 'home_screen.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with SingleTickerProviderStateMixin {
  double _opacity = 0.0;

  @override
  void initState() {
    super.initState();
    startTime();
    animateOpacity();
  }

  startTime() async {
    var duration = const Duration(seconds: 2);
    return Timer(duration, navigateToNextScreen);
  }

  void animateOpacity() {
    setState(() {
      _opacity = _opacity == 0.0 ? 1.0 : 0.0;
    });

    Future.delayed(const Duration(milliseconds: 1000), () {
      if (mounted) {
        animateOpacity();
      }
    });
  }

  void navigateToNextScreen() {
    Navigator.of(context).pushReplacement(
      MaterialPageRoute(
          builder: (context) =>
              const RegistrationScreen()), // Replace HomeScreen with your desired home screen widget
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF81DBDB),
      body: Center(
        child: FractionallySizedBox(
          widthFactor: 1,
          heightFactor: 1,
          child: AnimatedOpacity(
            opacity: _opacity,
            duration: const Duration(milliseconds: 1000),
            child: Image.asset('lib/assets/images/splashscreen_4_nobg.png'),
          ),
        ),
      ),
    );
  }
}
