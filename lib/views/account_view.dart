// ignore_for_file: depend_on_referenced_packages, import_of_legacy_library_into_null_safe, library_private_types_in_public_api

import 'package:flutter_application_demo/models/check_if_user_logged_in.dart';
import 'package:flutter_application_demo/views/body_widgets/auth_body.dart';
import 'package:flutter_application_demo/views/body_widgets/profile_body.dart';
import "package:flutter/material.dart";
import 'package:provider/provider.dart';

class AccountView extends StatefulWidget {
  const AccountView({super.key});

  @override
  _AccountViewState createState() => _AccountViewState();
}

class _AccountViewState extends State<AccountView> {
  @override
  Widget build(BuildContext context) {
    return Provider.of<CheckIfUserLoggedIn>(context).getCurrentUser()
        ? const ProfileBody()
        : const AuthBody();
  }
}

// 1234567
