// ignore_for_file: must_be_immutable

import 'package:flutter/material.dart';
import 'package:flutter_profile_picture/flutter_profile_picture.dart';

class UserDisplayGame extends StatefulWidget {
  String firstName;
  String lastName;
  UserDisplayGame({super.key, required this.firstName, required this.lastName});

  @override
  State<UserDisplayGame> createState() => _UserDisplayGameState();
}

class _UserDisplayGameState extends State<UserDisplayGame> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Container(
        width: double.infinity,
        height: 40,
        color: const Color.fromARGB(0, 255, 255, 255),
        child: Row(
          children: [
            Text(
              "${widget.firstName}, ${widget.lastName}",
              style: const TextStyle(
                  fontSize: 20,
                  color: Colors.black,
                  fontWeight: FontWeight.bold),
            ),
            const Spacer(),
            ProfilePicture(
                random: false,
                name: "${widget.firstName} ${widget.lastName}",
                radius: 20,
                fontsize: 10),
          ],
        ),
      ),
    );
  }
}
