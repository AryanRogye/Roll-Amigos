import 'package:dice_pt2/models/start_room_entry.dart';
import 'package:flutter/material.dart';

class DrawStartGameOptions extends StatefulWidget {
  final TextEditingController roomNameController;
  final TextEditingController passwordController;
  final Function() drawStartRoomButton;

  DrawStartGameOptions({
    super.key,
    required this.roomNameController,
    required this.passwordController,
    required this.drawStartRoomButton,
  });

  @override
  State<DrawStartGameOptions> createState() => _DrawStartGameOptionsState();
}

class _DrawStartGameOptionsState extends State<DrawStartGameOptions> {
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: <Widget>[
          const SizedBox(height: 10),
          //THIS IS THE TITLE OF THE BOTTOM SHEET
          const SizedBox(height: 20),
          //THIS IS THE TEXTFIELD
          StartRoomEntry(
            textfieldController: widget.roomNameController,
            hintText: 'Enter a Room Name',
          ),
          const SizedBox(height: 20),
          widget.drawStartRoomButton(),
        ],
      ),
    );
  }
}
