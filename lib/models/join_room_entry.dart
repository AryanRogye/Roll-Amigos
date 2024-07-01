// ignore_for_file: must_be_immutable

import 'package:flutter/material.dart';

class JoinRoomEntry extends StatefulWidget {
  TextEditingController textfieldController;
  String hintText;
  JoinRoomEntry(
      {super.key, required this.textfieldController, required this.hintText});

  @override
  State<JoinRoomEntry> createState() => _JoinRoomEntryState();
}

class _JoinRoomEntryState extends State<JoinRoomEntry> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      child: TextField(
        style: const TextStyle(color: Colors.black, fontSize: 40),
        controller: widget.textfieldController,
        //need to make sure only numbers are allowed
        keyboardType: TextInputType.numberWithOptions(signed: false, decimal: true),
        decoration: InputDecoration(
          hintText: widget.hintText,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(13),
            borderSide:
                const BorderSide(color: Color.fromARGB(0, 255, 255, 255)),
          ),
        ),
      ),
    );
  }
}
