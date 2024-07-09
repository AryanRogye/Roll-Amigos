// ignore_for_file: must_be_immutable

import 'package:dice_pt2/themes/const_themes.dart';
import 'package:flutter/material.dart';

class MyGameStart extends StatefulWidget {
  String text;
  Color? colorBackground;
  void Function() onTapFunction;

  MyGameStart(
      {super.key,
      required this.text,
      required this.colorBackground,
      required this.onTapFunction});

  @override
  State<MyGameStart> createState() => _MyGameStartState();
}

class _MyGameStartState extends State<MyGameStart> {
  //need to split the text into 2 meaning "Start" and "Game"
  String firstSplitText = "";
  String secondSplitText = "";

  @override
  void initState() {
    super.initState();
    List<String> splitText = widget.text.split(" ");
    setState(() {
      firstSplitText = splitText[0];
      secondSplitText = splitText[1];
    });
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        widget.onTapFunction();
      },
      child: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Container(
            decoration: constThemes.myBoxDecoration,
            width: MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.height * 0.2,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  firstSplitText,
                  style: constThemes.getWorkSansFont(
                    Colors.white,
                    30,
                    FontWeight.bold,
                  ),
                ),
                Text(
                  secondSplitText,
                  style: constThemes.getWorkSansFont(
                    Colors.white,
                    30,
                    FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
