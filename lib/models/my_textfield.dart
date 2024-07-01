// ignore_for_file: must_be_immutable

import 'package:flutter/material.dart';

class MyTextfield extends StatefulWidget {
  late TextEditingController textfieldController = TextEditingController();
  String? hintText;
  bool obscureText;

  MyTextfield({
    super.key,
    required this.textfieldController,
    required this.hintText,
    required this.obscureText,
  });
  @override
  State<MyTextfield> createState() => _MyTextfieldState();
}

class _MyTextfieldState extends State<MyTextfield> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 25),
      child: Container(
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: const Color.fromARGB(255, 111, 129, 104),
          border: Border.all(color: const Color.fromARGB(255, 131, 151, 122)),
          borderRadius: BorderRadius.circular(13),
        ),
        child: Padding(
          padding: const EdgeInsets.only(left: 10),
          child: TextField(
            controller: widget.textfieldController,
            autocorrect: false,
            obscureText: widget.obscureText,
            decoration: InputDecoration(
              border: InputBorder.none,
              hintText: widget.hintText,
            ),
          ),
        ),
      ),
    );
  }
}
