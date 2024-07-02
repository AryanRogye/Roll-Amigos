import 'package:dice_pt2/pages/auth/auth_page.dart';
import 'package:dice_pt2/pages/screen_navigation.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class HomePage extends StatelessWidget {
  final SharedPreferences prefs;
  const HomePage({super.key, required this.prefs});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: StreamBuilder<User?>(
          stream: FirebaseAuth.instance.authStateChanges(),
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              prefs.setBool('onboard', true);
              // rn doing screen_navigation.dart
              // change to startingPage if something messes up
              return ScreenNavigation(prefs: prefs);
            } else {
              return AuthPage(prefs: prefs);
            }
          }),
    );
  }
}
