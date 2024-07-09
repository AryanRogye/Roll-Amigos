// ignore_for_file: must_be_immutable

import 'package:dice_pt2/themes/const_themes.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class MyNameEntry extends StatefulWidget {
  String hintText;
  TextEditingController textfieldController;

  MyNameEntry({
    super.key,
    required this.hintText,
    required this.textfieldController,
  });

  @override
  State<MyNameEntry> createState() => _MyNameEntryState();
}

class _MyNameEntryState extends State<MyNameEntry> {
  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment.center,
      decoration: constThemes.myBoxDecoration,
      child: Padding(
        padding: const EdgeInsets.all(10),
        child: TextField(
          controller: widget.textfieldController,
          autocorrect: false,
          decoration: InputDecoration(
            border: InputBorder.none,
            hintText: widget.hintText,
            hintStyle: constThemes.getWorkSansFont(
              const Color.fromARGB(255, 128, 128, 128),
              15,
              FontWeight.normal,
            ),
          ),
        ),
      ),
    );
  }
}
