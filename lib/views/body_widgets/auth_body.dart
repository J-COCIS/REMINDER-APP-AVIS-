// ignore_for_file: depend_on_referenced_packages, library_private_types_in_public_api, unused_field, unused_local_variable, import_of_legacy_library_into_null_safe, use_build_context_synchronously

import 'package:flutter_application_demo/models/check_if_user_logged_in.dart';
import 'package:flutter_application_demo/views/body_widgets/resetPassword.dart';
import 'package:flutter_application_demo/widgets/custom_text_form_field.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_progress_hud/flutter_progress_hud.dart';
import 'package:provider/provider.dart';

import 'package:flutter_screenutil/flutter_screenutil.dart';

class AuthBody extends StatefulWidget {
  const AuthBody({super.key});

  @override
  _AuthBodyState createState() => _AuthBodyState();
}

class _AuthBodyState extends State<AuthBody> {
  String _requestedBody = 'login';
  bool _isLoading = false;
  bool _obscureText = true;

  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _showSpinner = false;

  _togglePasswordVisibility() {
    setState(() {
      _obscureText = !_obscureText;
    });
  }

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
                  color: Colors.white,
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

  final FirebaseAuth _auth = FirebaseAuth.instance;

  Future<void> _submitSignIn() async {
    // Perform submit action

    setState(() {
      _showSpinner = true;
    });

    if (_formKey.currentState!.validate()) {
      // Form validation success
      try {
        setState(() {
          _isLoading = true;
        });
        await Future.delayed(const Duration(seconds: 2));
        final user = await _auth.signInWithEmailAndPassword(
            email: _emailController.text, password: _passwordController.text);

        setState(() {
          _showSpinner = false;
          Provider.of<CheckIfUserLoggedIn>(context, listen: false)
              .changeState(true);
        });
      } catch (e) {
        setState(() {
          _isLoading = false;
        });
        String errorMessage = 'An error occurred. Please try again.';
        if (e is FirebaseAuthException) {
          errorMessage = e.message!;
        }
        showErrorDialog(context, errorMessage);
      }
    } else {
      setState(() {
        _isLoading = false;
      });
    }
  }

  Future<void> _submitSignUp() async {
    // Perform submit action

    setState(() {
      _showSpinner = true;
    });

    if (_formKey.currentState!.validate()) {
      // Form validation success
      try {
        setState(() {
          _isLoading = true;
        });
        await Future.delayed(const Duration(seconds: 2));
        final newUser = await _auth.createUserWithEmailAndPassword(
          email: _emailController.text,
          password: _passwordController.text,
        );

        showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: const Text(
                'Success Alert!!!',
                style: TextStyle(
                  color: Colors.black,
                  fontFamily: 'Fantasque',
                ),
              ),
              content: const Text(
                'You have sucessfully created an account, you can now login ',
                style: TextStyle(
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
                      color: Colors.white,
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

        setState(() {
          _showSpinner = false;
          Provider.of<CheckIfUserLoggedIn>(context, listen: false)
              .changeState(true);
        });
      } catch (e) {
        setState(() {
          _isLoading = false;
        });
        String errorMessage = 'An error occurred. Please try again.';
        if (e is FirebaseAuthException) {
          errorMessage = e.message!;
        }
        showErrorDialog(context, errorMessage);
      }
    } else {
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    ScreenUtil.init(
      context,
      designSize: const Size(432.0, 816.0),
    );

    return ProgressHUD(
      barrierColor: Colors.transparent,
      child: Builder(
        builder: (BuildContext context) {
          return Stack(children: [
            if (_isLoading)
              const Center(
                  child: CircularProgressIndicator(
                color: Colors.black,
              )),
            Padding(
              padding:
                  EdgeInsets.symmetric(horizontal: 20.0.w, vertical: 20.0.h),
              child: _requestedBody == 'login'
                  ? ListView(
                      children: [
                        Column(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            const Text(
                              'Welcome Back,',
                              style: TextStyle(
                                color: Colors.black,
                                fontSize: 25.5,
                                fontWeight: FontWeight.w500,
                                fontFamily: 'Fantasque',
                              ),
                            ),
                            SizedBox(height: 3.0.h),
                            const Text(
                              'Login to save your reminders on all devices.',
                              style: TextStyle(
                                fontSize: 16.0,
                                fontFamily: 'Fantasque',
                                color: Colors.black,
                              ),
                            ),
                            Container(
                              margin: EdgeInsets.symmetric(vertical: 20.0.h),
                              width: 200.0.w,
                              height: 200.0.h,
                              alignment: Alignment.center,
                              decoration: const BoxDecoration(
                                image: DecorationImage(
                                  image: AssetImage('assets/images/login.png'),
                                  fit: BoxFit.contain,
                                ),
                              ),
                            ),
                            Form(
                              key: _formKey,
                              child: Column(
                                children: <Widget>[
                                  CustomTextFormField(
                                    labelText: 'Email',
                                    textInputType: TextInputType.emailAddress,
                                    obscureText: false,
                                    errorText: 'Please input email address',
                                    controller: _emailController,
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.only(
                                        top: 10.0, bottom: 10.0),
                                    child: CustomTextFormField(
                                      labelText: 'Password',
                                      obscureText: _obscureText,
                                      errorText: 'Please input password',
                                      controller: _passwordController,
                                      textInputType: TextInputType.text,
                                      suffixIcon: IconButton(
                                        icon: Icon(
                                          // Choose the icon based on the visibility status
                                          _obscureText
                                              ? Icons.visibility
                                              : Icons.visibility_off,
                                          color: Colors.black,
                                        ),
                                        onPressed: _togglePasswordVisibility,
                                      ),
                                    ),
                                  ),
                                  Align(
                                    alignment: Alignment.topRight,
                                    child: GestureDetector(
                                      child: const Text(
                                        "Forgot Password?",
                                        style: TextStyle(
                                          color: Colors.black,
                                          fontFamily: 'Fantasque',
                                          fontWeight: FontWeight.w800,
                                        ),
                                      ),
                                      onTap: () {
                                        Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                              builder: (context) =>
                                                  const ForgotPasswordScreen()),
                                        );
                                      },
                                    ),
                                  ),
                                  SizedBox(height: 25.0.h),
                                  ButtonTheme(
                                      minWidth:
                                          MediaQuery.of(context).size.width /
                                              1.5,
                                      height: 50.0,
                                      child: ElevatedButton(
                                        style: ElevatedButton.styleFrom(
                                          elevation: 10.0,
                                          backgroundColor: Colors.black,
                                          shape: RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(25.0),
                                          ),
                                          padding: const EdgeInsets.only(
                                            left: 15.0,
                                            bottom: 11.0,
                                            top: 11.0,
                                            right: 15.0,
                                          ),
                                        ),
                                        onPressed:
                                            _isLoading ? null : _submitSignIn,
                                        child: Text(
                                          _isLoading
                                              ? 'Logging in...'
                                              : 'Login',
                                          style: const TextStyle(
                                            fontSize: 20.0,
                                            color: Colors.white,
                                            fontFamily: 'Fantasque',
                                          ),
                                        ),
                                      )),
                                  SizedBox(height: 16.0.h),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: <Widget>[
                                      const Text(
                                        "Don't have an account? ",
                                        style: TextStyle(
                                          color: Colors.black,
                                          fontFamily: 'Fantasque',
                                        ),
                                      ),
                                      GestureDetector(
                                        child: const Text(
                                          "Sign Up",
                                          style: TextStyle(
                                            color: Colors.black,
                                            fontFamily: 'Fantasque',
                                            fontWeight: FontWeight.w800,
                                          ),
                                        ),
                                        onTap: () {
                                          setState(() {
                                            _requestedBody = 'signup';
                                          });
                                        },
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ],
                    )
                  : SingleChildScrollView(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          const Text(
                            'Create Your Account,',
                            style: TextStyle(
                              color: Colors.black,
                              fontSize: 25.5,
                              fontWeight: FontWeight.w500,
                              fontFamily: 'Fantasque',
                            ),
                          ),
                          SizedBox(height: 3.0.h),
                          const Text(
                            'Sign up and get started.',
                            style: TextStyle(
                                fontSize: 16.0,
                                fontFamily: 'Fantasque',
                                color: Colors.black),
                          ),
                          Container(
                            margin:
                                EdgeInsets.only(top: 10.0.h, bottom: 10.0.h),
                            width: 220.0.w,
                            height: 220.0.h,
                            alignment: Alignment.center,
                            decoration: const BoxDecoration(
                              image: DecorationImage(
                                image: AssetImage('assets/images/signup.png'),
                                fit: BoxFit.contain,
                              ),
                            ),
                          ),
                          Form(
                            key: _formKey,
                            child: Column(
                              children: <Widget>[
                                CustomTextFormField(
                                  labelText: 'Name',
                                  textInputType: TextInputType.name,
                                  obscureText: false,
                                  errorText: 'Please enter your name',
                                  controller: _nameController,
                                ),
                                Padding(
                                  padding: EdgeInsets.only(
                                      top: 10.0.h, bottom: 10.0.h),
                                  child: CustomTextFormField(
                                    labelText: 'Email',
                                    textInputType: TextInputType.emailAddress,
                                    obscureText: false,
                                    errorText: 'Please input email address',
                                    controller: _emailController,
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.only(bottom: 10.0),
                                  child: CustomTextFormField(
                                    labelText: 'Password',
                                    obscureText: _obscureText,
                                    errorText: 'Please input password',
                                    controller: _passwordController,
                                    textInputType: TextInputType.text,
                                    suffixIcon: IconButton(
                                      icon: Icon(
                                        // Choose the icon based on the visibility status
                                        _obscureText
                                            ? Icons.visibility
                                            : Icons.visibility_off,
                                        color: Colors.black,
                                      ),
                                      onPressed: _togglePasswordVisibility,
                                    ),
                                  ),
                                ),
                                SizedBox(height: 30.0.h),
                                ButtonTheme(
                                  minWidth:
                                      MediaQuery.of(context).size.width / 1.5,
                                  height: 50.0,
                                  child: ElevatedButton(
                                    style: ButtonStyle(
                                      backgroundColor:
                                          MaterialStateProperty.all(
                                              Colors.black),
                                      shape: MaterialStateProperty.all(
                                        RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(25.0),
                                        ),
                                      ),
                                      padding: MaterialStateProperty.all(
                                        const EdgeInsets.only(
                                          left: 15.0,
                                          bottom: 11.0,
                                          top: 11.0,
                                          right: 15.0,
                                        ),
                                      ),
                                    ),
                                    onPressed:
                                        _isLoading ? null : _submitSignUp,
                                    child: Text(
                                      _isLoading
                                          ? 'Creating account...'
                                          : 'SignUp',
                                      style: const TextStyle(
                                        fontSize: 20.0,
                                        color: Colors.white,
                                        fontFamily: 'Fantasque',
                                      ),
                                    ),
                                  ),
                                ),
                                const SizedBox(height: 30.0),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: <Widget>[
                                    const Text(
                                      "Already have an account? ",
                                      style: TextStyle(
                                        color: Colors.black,
                                        fontFamily: 'Fantasque',
                                      ),
                                    ),
                                    GestureDetector(
                                      child: const Text(
                                        "LogIn",
                                        style: TextStyle(
                                          color: Colors.black,
                                          fontFamily: 'Fantasque',
                                          fontWeight: FontWeight.w800,
                                        ),
                                      ),
                                      onTap: () {
                                        setState(() {
                                          _requestedBody = 'login';
                                        });
                                      },
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 180.0),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
            ),
          ]);
        },
      ),
    );
  }
}
