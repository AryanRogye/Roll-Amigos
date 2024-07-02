import 'package:dice_pt2/components/firebase/firebase_functions.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

class SettingsPage extends StatefulWidget {
  const SettingsPage({super.key});

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
          // drawChangePassword(),
          // Container(color: Colors.black, height: 1),
          // drawSignOut(),
        ],
      ),
    );
  }

  drawProfilePicture() {
    return Container(
      alignment: Alignment.center,
      width: double.infinity,
      height: 80,
      color: const Color.fromARGB(255, 255, 255, 255),
      child: const Text(
        "Profile Picture",
        style: TextStyle(
          fontSize: 24,
          fontWeight: FontWeight.bold,
          color: Colors.black,
        ),
      ),
    );
  }

  Future<dynamic> getFirstNameAndLastName() async {
    return await FirebaseFunctions.getFirstNameLastName();
  }

  drawDisplayName() {
    return FutureBuilder(
      future: getFirstNameAndLastName(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.done) {
          print("DONE");
          print("Data: ${snapshot.data}");
          //snapshot.data is a list
          var firstName = snapshot.data[0];
          var lastName = snapshot.data[1];

          return Container(
            alignment: Alignment.center,
            width: double.infinity,
            height: 80,
            color: const Color.fromARGB(255, 255, 255, 255),
            child: Text(
              "$firstName $lastName",
              style: const TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ),
            ),
          );
        } else {
          return CircularProgressIndicator();
        }
      },
    );
  }

  drawDisplayEmail() {
    return Container(
      alignment: Alignment.center,
      width: double.infinity,
      height: 80,
      color: const Color.fromARGB(255, 255, 255, 255),
      child: const Text(
        "email address",
        style: TextStyle(
          fontSize: 24,
          fontWeight: FontWeight.bold,
          color: Colors.black,
        ),
      ),
    );
  }
}
