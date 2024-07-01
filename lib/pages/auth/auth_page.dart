import 'package:dice_pt2/pages/auth/sign_in_page.dart';
import 'package:dice_pt2/pages/auth/register_page.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AuthPage extends StatefulWidget {
  final SharedPreferences prefs;
  const AuthPage({super.key, required this.prefs});

  @override
  State<AuthPage> createState() => _AuthPageState();
}

class _AuthPageState extends State<AuthPage> {
  //initially need to show the login page
  bool showLogin = true;

  void toggleScreen() {
    setState(() {
      showLogin = !showLogin;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (showLogin) {
      return SignInPage(showRegisterPage: toggleScreen);
    } else {
      return RegisterPage(showRegisterPage: toggleScreen, prefs: widget.prefs);
    }
  }
}
