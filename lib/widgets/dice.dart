// ignore_for_file: must_be_immutable

import 'package:flutter/material.dart';

//basically the class to display which dice it is and the number
//all the images are in the assets just need to find a way to see which dice it is
class DiceWidget extends StatelessWidget {
  //requiring to show the dice number
  late List<int> diceNumber;
  //if true then showing the white dice else black dice
  late bool isWhite;
  late double screenWidth;
  late double screenHeight;
  late int numOfDices;

  DiceWidget({
    super.key,
    required this.diceNumber,
    required this.isWhite,
    required this.screenWidth,
    required this.screenHeight,
    required this.numOfDices,
  });

  @override
  Widget build(BuildContext context) {
    //now I need to check how to display the dice
    //if one will keey it like this if 2 need them on top of each other so will prolly do a center with a column
    //if 3 need to do 2 in a row and one in the middle of them
    if (numOfDices == 1) {
      print('numOfDices: is 1');
      return SizedBox(
        width: screenWidth * 0.3,
        height: screenHeight * 0.15,
        child: getDice(diceNumber[0]),
      );
    } else if (numOfDices == 2) {
      print('numOfDices: is 2');
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SizedBox(
              width: screenWidth * 0.3,
              height: screenHeight * 0.15,
              child: getDice(diceNumber[0]),
            ),
            const SizedBox(
              height: 20,
            ),
            SizedBox(
              width: screenWidth * 0.3,
              height: screenHeight * 0.15,
              child: getDice(diceNumber[1]),
            ),
          ],
        ),
      );
    } else if (numOfDices == 3) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Row(mainAxisAlignment: MainAxisAlignment.center, children: [
              SizedBox(
                width: screenWidth * 0.3,
                height: screenHeight * 0.15,
                child: getDice(diceNumber[0]),
              ),
              const SizedBox(width: 20),
              SizedBox(
                width: screenWidth * 0.3,
                height: screenHeight * 0.15,
                child: getDice(diceNumber[1]),
              ),
            ]),
            const SizedBox(height: 20),
            SizedBox(
              width: screenWidth * 0.3,
              height: screenHeight * 0.15,
              child: getDice(diceNumber[2]),
            ),
          ],
        ),
      );
    } else {
      return const SizedBox();
    }
  }

  Widget getDice(int diceNum) {
    // double diceSize = screenWidth;

    return Image.asset(
      isWhite
          ? 'assets/images/dice-$diceNum-white.png'
          : 'assets/images/dice-$diceNum-dark.png',
      fit: BoxFit.fill,
    );
  }
}
