// ignore_for_file: library_private_types_in_public_api, depend_on_referenced_packages

import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../../widgets/custom_text_form_field.dart';

void showErrorDialog(BuildContext context, String errorMessage) {
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        title: const Text(
          'Error',
          style: TextStyle(
            color: Color.fromARGB(255, 243, 35, 20),
            fontFamily: 'Fantasque',
          ),
        ),
        content: Text(
          errorMessage,
          style: const TextStyle(
            color: Colors.black,
            fontFamily: 'Fantasque',
          ),
        ),
        actions: <Widget>[
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.black,
              elevation: 5.0,
            ),
            child: const Text(
              'OK',
              style: TextStyle(
                fontFamily: 'Fantasque',
              ),
            ),
            onPressed: () {
              Navigator.of(context).pop();
            },
          ),
        ],
      );
    },
  );
}

Future<void> resetPassword(String email, context) async {
  try {
    await FirebaseAuth.instance.sendPasswordResetEmail(email: email);

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text(
            'Success Alert!!!!',
            style: TextStyle(
              color: Colors.black,
              fontFamily: 'Fantasque',
            ),
          ),
          content: const Text(
            'The link for resetting your password has been sent sucessfully, check your email',
            style: TextStyle(
              fontFamily: 'Fantasque',
              color: Colors.black,
            ),
          ),
          actions: <Widget>[
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.black,
                elevation: 5.0,
              ),
              child: const Text('OK'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
    // Password reset email sent successfully
  } catch (e) {
    String errorMessage = 'An error occurred. Please try again.';
    if (e is FirebaseAuthException) {
      errorMessage = e.message!;
    }
    showErrorDialog(context, errorMessage);
  }
}

class ForgotPasswordScreen extends StatefulWidget {
  const ForgotPasswordScreen({super.key});

  @override
  _ForgotPasswordScreenState createState() => _ForgotPasswordScreenState();
}

class _ForgotPasswordScreenState extends State<ForgotPasswordScreen> {
  final _emailController = TextEditingController();

  @override
  void dispose() {
    _emailController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: Colors.amber,
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: const Text(
          'Forgot Password',
          style: TextStyle(
            color: Colors.black,
            fontSize: 25.0,
            fontFamily: 'Fantasque',
            fontWeight: FontWeight.w700,
          ),
        ),
        leading: IconButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          icon: const Icon(
            Icons.arrow_back_ios,
          ),
          color: Colors.black,
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const Text(
              'Enter the Email you registered',
              style: TextStyle(
                color: Colors.black,
              ),
            ),
            const SizedBox(
              height: 10,
            ),
            CustomTextFormField(
              labelText: 'Email',
              textInputType: TextInputType.emailAddress,
              obscureText: false,
              errorText: 'Please input email address',
              controller: _emailController,
            ),
            const SizedBox(height: 16.0),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.black,
                elevation: 8.0,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20.0),
                ),
                padding: const EdgeInsets.only(
                  left: 15,
                  bottom: 11,
                  top: 11,
                  right: 15,
                ),
              ),
              onPressed: () {
                String email = _emailController.text;
                resetPassword(email, context);
              },
              child: const Text(
                'Reset Password',
              ),
            ),
          ],
        ),
      ),
    );
  }
}
