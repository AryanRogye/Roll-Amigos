import 'package:dice_pt2/components/firebase/firebase_functions.dart';
import 'package:flutter/material.dart';

class UserCountWidget extends StatelessWidget {
  final String roomName;

  const UserCountWidget({super.key, required this.roomName});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<int>(
      stream: FirebaseFunctions.getNumOfUsers(roomName: roomName),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const CircularProgressIndicator();
        } else if (snapshot.hasError) {
          return Text(
            "Error: ${snapshot.error.toString()}",
            style: const TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          );
        } else if (snapshot.hasData) {
          return Text(
            "Users: ${snapshot.data}",
            style: const TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          );
        } else {
          return const Text(
            "No Data",
            style: TextStyle(
              color: Colors.white,
            ),
          );
        }
      },
    );
  }
}


