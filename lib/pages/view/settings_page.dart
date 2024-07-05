// ignore_for_file: must_be_immutable

import 'package:dice_pt2/components/firebase/firebase_functions.dart';
import 'package:dice_pt2/pages/auth/forgot_pw.dart';
import 'package:flutter/material.dart';
import 'package:flutter_profile_picture/flutter_profile_picture.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SettingsPage extends StatefulWidget {
  SharedPreferences prefs;
  SettingsPage({
    super.key,
    required this.prefs,
  });

  @override
  State<SettingsPage> createState() => _SettingsPagecState();
}

//settings page needs to look like this
// profile picture
// display name
// email
// need the option to change the password
// need the option to sign out

class _SettingsPagecState extends State<SettingsPage> {
  bool signOutConfirm = false;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Settings'),
      ),
      body: Column(
        children: [
          drawProfilePicture(),
          Container(color: Colors.black, height: 1),
          drawDisplayName(),
          Container(color: Colors.black, height: 1),
          drawDisplayEmail(),
          Container(color: Colors.black, height: 1),
          drawChangePassword(),
          Container(color: Colors.black, height: 1),
          drawSignOut(),
          Container(color: Colors.black, height: 1),
        ],
      ),
    );
  }

  drawProfilePicture() {
    return FutureBuilder(
      future: FirebaseFunctions.getFirstNameLastName(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.done) {
          var names = snapshot.data;
          ;
          return ProfilePicture(
              name: "${names[0]} ${names[1]}", radius: 60, fontsize: 50);
        } else {
          return const CircularProgressIndicator();
        }
      },
    );
  }

  Future<dynamic> getFirstNameAndLastName() async {
    return await FirebaseFunctions.getFirstNameLastName();
  }

  drawDisplayName() {
    return FutureBuilder(
      future: FirebaseFunctions.getFirstNameLastName(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.done) {
          var names = snapshot.data;
          return Container(
            alignment: Alignment.center,
            width: double.infinity,
            height: 80,
            color: const Color.fromARGB(0, 255, 255, 255),
            child: Text(
              "${names[0]} ${names[1]}",
              style: const TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
          );
        } else {
          return const CircularProgressIndicator();
        }
      },
    );
  }

  drawDisplayEmail() {
    return FutureBuilder(
      future: FirebaseFunctions.getEmail(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.done) {
          var email = snapshot.data;
          return Container(
            alignment: Alignment.center,
            width: double.infinity,
            height: 80,
            color: const Color.fromARGB(0, 255, 255, 255),
            child: Text(
              "$email",
              style: const TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
          );
        } else {
          return const CircularProgressIndicator();
        }
      },
    );
  }

  drawChangePassword() {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => const ForgotPw(),
          ),
        );
      },
      child: Container(
        alignment: Alignment.center,
        width: double.infinity,
        height: 80,
        color: const Color.fromARGB(0, 255, 255, 255),
        child: const Text("change password",
            style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Colors.white)),
      ),
    );
  }

  drawSignOut() {
    return GestureDetector(
      onTap: () {
        showExitDialog();
      },
      child: Container(
        width: double.infinity,
        height: 80,
        alignment: Alignment.center,
        //need to show a exit icon
        child: const Icon(Icons.exit_to_app, color: Colors.white, size: 40),
      ),
    );
  }

  Future<dynamic> showExitDialog() async {
    return showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text("Sign Out",
              style: TextStyle(
                color: Colors.black,
                fontWeight: FontWeight.bold,
              )),
          content: const Text("Are you sure you want to sign out?",
              style: TextStyle(
                color: Colors.black,
              )),
          actions: [
            TextButton(
              onPressed: () {
                print("No");
                Navigator.pop(context);
              },
              child: const Text("No"),
            ),
            TextButton(
              onPressed: () {
                print("Yes");
                Navigator.pop(context);
                FirebaseFunctions.signOut(prefs: widget.prefs);
              },
              child: const Text("Yes"),
            ),
          ],
        );
      },
    );
  }
}
