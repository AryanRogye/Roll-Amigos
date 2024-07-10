// ignore_for_file: must_be_immutable

import 'package:dice_pt2/themes/const_themes.dart';
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
      style: constThemes.getWorkSansFont(Colors.white, 20, FontWeight.normal),
      controller: widget.textfieldController,
      decoration: InputDecoration(
        fillColor: Colors.black12,
        filled: true,
        hintText: widget.hintText,
        hintStyle: constThemes.hintTextTheme,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(13),
        ),
      ),
    );
  }
}
