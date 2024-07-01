// ignore_for_file: must_be_immutable

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
          decoration: BoxDecoration(
            color: const Color.fromARGB(255, 149, 172, 140),
            border: Border.all(color: const Color.fromARGB(255, 183, 211, 170)),
            borderRadius: BorderRadius.circular(13),
          ),
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
