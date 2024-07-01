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
      decoration: BoxDecoration(
        color: const Color.fromARGB(255, 111, 129, 104),
        border: Border.all(color: const Color.fromARGB(255, 131, 151, 122)),
        borderRadius: BorderRadius.circular(13),
      ),
      child: Padding(
        padding: const EdgeInsets.all(10),
        child: TextField(
          controller: widget.textfieldController,
          autocorrect: false,
          decoration: InputDecoration(
            border: InputBorder.none,
            hintText: widget.hintText,
          ),
        ),
      ),
    );
  }
}
