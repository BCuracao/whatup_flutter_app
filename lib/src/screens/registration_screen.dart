import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:whatup/src/screens/home_screen.dart';

class RegistrationScreen extends StatefulWidget {
  const RegistrationScreen({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _RegistrationScreenState createState() => _RegistrationScreenState();
}

class _RegistrationScreenState extends State<RegistrationScreen> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final TextEditingController _phoneNumberController = TextEditingController();
  final TextEditingController _smsCodeController = TextEditingController();
  late String _verificationId;
  bool _isPhoneNumberSubmitted = false;

  void _sendVerificationCode() async {
    await _auth.verifyPhoneNumber(
      phoneNumber: _phoneNumberController.text,
      verificationCompleted: (PhoneAuthCredential credential) async {
        await _auth.signInWithCredential(credential);
      },
      verificationFailed: (FirebaseAuthException e) {
        // Handle the error
        print(e);
      },
      codeSent: (String verificationId, int? resendToken) {
        setState(() {
          _verificationId = verificationId;
          _isPhoneNumberSubmitted = true;
        });
      },
      codeAutoRetrievalTimeout: (String verificationId) {
        setState(() {
          _verificationId = verificationId;
        });
      },
    );
  }

  void _signInWithPhoneNumber() async {
    final AuthCredential credential = PhoneAuthProvider.credential(
      verificationId: _verificationId,
      smsCode: _smsCodeController.text,
    );
    try {
      await _auth.signInWithCredential(credential);
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => HomeScreen()),
      );
    } catch (e) {
      // Handle the error
      print(e);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFF81DBDB),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            if (!_isPhoneNumberSubmitted) ...[
              TextField(
                controller: _phoneNumberController,
                decoration: InputDecoration(
                  hintText: 'Enter your phone number',
                ),
                keyboardType: TextInputType.phone,
              ),
              ElevatedButton(
                onPressed: _sendVerificationCode,
                child: Text('Send Verification Code'),
              ),
            ] else ...[
              TextField(
                controller: _smsCodeController,
                decoration: InputDecoration(
                  hintText: 'Enter the verification code',
                ),
                keyboardType: TextInputType.number,
              ),
              ElevatedButton(
                onPressed: _signInWithPhoneNumber,
                child: Text('Sign In'),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
