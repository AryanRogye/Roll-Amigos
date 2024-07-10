import 'package:dice_pt2/models/join_room_entry.dart';
import 'package:dice_pt2/models/start_room_entry.dart';
import 'package:flutter/material.dart';

class DrawJoinGameOptions extends StatefulWidget {
  final TextEditingController roomNameController;
  final TextEditingController passwordController;
  final Function() drawJoinRoomButton;

  DrawJoinGameOptions({
    super.key,
    required this.roomNameController,
    required this.passwordController,
    required this.drawJoinRoomButton,
  });

  @override
  State<DrawJoinGameOptions> createState() => _DrawJoinGameOptionsState();
}

class _DrawJoinGameOptionsState extends State<DrawJoinGameOptions> {
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: <Widget>[
          const SizedBox(height: 10),
          //THIS IS THE TITLE OF THE BOTTOM SHEET
          const SizedBox(height: 20),
          //THIS IS THE TEXTFIELD
          JoinRoomEntry(
            textfieldController: widget.passwordController,
            hintText: 'Pin',
          ),
          const SizedBox(height: 20),
          widget.drawJoinRoomButton(),
        ],
      ),
    );
  }
}
