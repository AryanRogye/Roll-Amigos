import 'package:dice_pt2/components/firebase/firebase_functions.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_profile_picture/flutter_profile_picture.dart';

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
      height: 130,
      color: const Color.fromARGB(0, 255, 255, 255),
      child: FutureBuilder(
        future: FirebaseFunctions.getFirstNameLastName(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            var firstName = snapshot.data[0];
            var lastName = snapshot.data[1];
            return ProfilePicture(
                name: "$firstName $lastName", radius: 50, fontsize: 40);
          } else {
            return const CircularProgressIndicator();
          }
        },
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
            color: const Color.fromARGB(0, 255, 255, 255),
            child: Text(
              "$firstName $lastName",
              style: const TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Colors.white,
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
    return FutureBuilder(
      future: FirebaseFunctions.getEmail(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.done) {
          print("DONE");
          print("Data: ${snapshot.data}");
          var email = snapshot.data;
          return Container(
            alignment: Alignment.center,
            width: double.infinity,
            height: 80,
            color: Color.fromARGB(0, 255, 255, 255),
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
          return CircularProgressIndicator();
        }
      },
    );
  }
}
