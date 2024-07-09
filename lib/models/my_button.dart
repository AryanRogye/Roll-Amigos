// ignore_for_file: must_be_immutable

import 'package:dice_pt2/themes/const_themes.dart';
import 'package:flutter/material.dart';

class MyButton extends StatefulWidget {
  var func;
  late String text;

  MyButton({super.key, required this.func, required this.text});
  @override
  State<MyButton> createState() => _MyButtonState();
}

class _MyButtonState extends State<MyButton> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 25),
      child: GestureDetector(
        onTap: widget.func,
        child: Container(
          padding: const EdgeInsets.all(20),
          decoration: constThemes.myBoxDecoration,
          child: Center(
            child: Text(widget.text,
                style:
                    const TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
          ),
        ),
      ),
    );
  }
}
