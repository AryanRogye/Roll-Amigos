// ignore_for_file: must_be_immutable

import 'package:flutter/material.dart';

class StartRoomEntry extends StatefulWidget {
  TextEditingController textfieldController;
  String hintText;
  StartRoomEntry(
      {super.key, required this.textfieldController, required this.hintText});

  @override
  State<StartRoomEntry> createState() => _StartRoomEntryState();
}

class _StartRoomEntryState extends State<StartRoomEntry> {
  @override
  Widget build(BuildContext context) {
    return TextField(
      style: const TextStyle(color: Colors.black, fontSize: 20),
      controller: widget.textfieldController,
      decoration: InputDecoration(
        fillColor: Colors.black12,
        filled: true,
        hintText: widget.hintText,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(13),
        ),
      ),
    );
  }
}
