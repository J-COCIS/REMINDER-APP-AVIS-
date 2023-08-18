// ignore_for_file: depend_on_referenced_packages, non_constant_identifier_names

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class CheckIfUserLoggedIn extends ChangeNotifier {
  bool _userLoggedIn = false;
  late User loggedInUser;

  String? getCurrentUserEmail() {
    loggedInUser = _auth.currentUser!;

    return loggedInUser.email;
  }

  final _auth = FirebaseAuth.instance;
  bool getCurrentUser() {
    try {
      if (_auth.currentUser != null) {
        _userLoggedIn = true;
      }
    } catch (e) {
      print(e);
    }

    return _userLoggedIn;
  }

  Future<void> SignOut() async {
    await _auth.signOut();
    _userLoggedIn = false;
  }

  void changeState(state) {
    _userLoggedIn = state;
    notifyListeners();
  }
}
