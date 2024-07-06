// ignore_for_file: must_be_immutable

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
            decoration: BoxDecoration(
              border: Border.all(color: Colors.grey.shade300),
              borderRadius: BorderRadius.circular(10),
              color: widget.colorBackground,
              // image: const DecorationImage(
              //     image: AssetImage("assets/images/buttonBackground.png"),
              //     fit: BoxFit.scaleDown,
              //     alignment: Alignment.centerRight),
            ),
            width: MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.height * 0.2,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(firstSplitText,
                    style: const TextStyle(
                      fontSize: 30,
                      color: Colors.black,
                      fontWeight: FontWeight.bold,
                    )),
                Text(
                  secondSplitText,
                  style: const TextStyle(
                      fontSize: 30,
                      color: Colors.black,
                      fontWeight: FontWeight.bold),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
