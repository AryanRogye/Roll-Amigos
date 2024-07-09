// ignore_for_file: must_be_immutable

import 'package:dice_pt2/themes/const_themes.dart';
import 'package:flutter/material.dart';

class MyTextfield extends StatefulWidget {
  late TextEditingController textfieldController = TextEditingController();
  String? hintText;
  bool obscureText;
  bool isPassword;

  MyTextfield({
    super.key,
    required this.textfieldController,
    required this.hintText,
    required this.obscureText,
    required this.isPassword,
  });
  @override
  State<MyTextfield> createState() => _MyTextfieldState();
}

class _MyTextfieldState extends State<MyTextfield> {
  var icon = const Icon(Icons.visibility_off, color: Colors.white);
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 25),
      child: Container(
        alignment: Alignment.center,
        decoration: constThemes.myBoxDecoration,
        child: Padding(
          padding: const EdgeInsets.only(left: 10),
          child: TextField(
            controller: widget.textfieldController,
            autocorrect: false,
            obscureText: widget.obscureText,
            cursorColor: Colors.white,
            decoration: InputDecoration(
              suffixIcon: widget.isPassword
                  ? IconButton(
                      icon: icon,
                      onPressed: () {
                        setState(() {
                          widget.obscureText = !widget.obscureText;
                          if (widget.obscureText) {
                            icon = const Icon(
                              Icons.visibility_off,
                              color: Colors.white,
                            );
                          } else {
                            icon = const Icon(
                              Icons.visibility,
                              color: Colors.white,
                            );
                          }
                        });
                      },
                    )
                  : null,
              border: InputBorder.none,
              hintText: widget.hintText,
              hintStyle: constThemes.hintTextTheme,
            ),
          ),
        ),
      ),
    );
  }
}
