import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

class Dice extends StatefulWidget {
  late List<int> diceNumber;
  late bool isRollingUser;
  late double screenWidth;
  late double screenHeight;
  late int numOfDices;
  Dice({
    super.key,
    required this.diceNumber,
    required this.screenWidth,
    required this.screenHeight,
    required this.numOfDices,
    required this.isRollingUser,
  });

  @override
  State<Dice> createState() => _DiceState();
}

class _DiceState extends State<Dice> {
  @override
  Widget build(BuildContext context) {
    if (widget.numOfDices == 1) {
      return SizedBox(
        width: widget.screenWidth * 0.3,
        height: widget.screenHeight * 0.15,
        child: getDice(widget.diceNumber[0]),
      );
    } else if (widget.isRollingUser == 2) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SizedBox(
              width: widget.screenHeight * 0.3,
              height: widget.screenHeight * 0.15,
              child: getDice(widget.diceNumber[0]),
            ),
            const SizedBox(
              height: 20,
            ),
            SizedBox(
              width: widget.screenWidth * 0.3,
              height: widget.screenHeight * 0.15,
              child: getDice(widget.diceNumber[1]),
            ),
          ],
        ),
      );
    } else if (widget.numOfDices == 3) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Row(mainAxisAlignment: MainAxisAlignment.center, children: [
              SizedBox(
                width: widget.screenWidth * 0.3,
                height: widget.screenHeight * 0.15,
                child: getDice(widget.diceNumber[0]),
              ),
              const SizedBox(width: 20),
              SizedBox(
                width: widget.screenWidth * 0.3,
                height: widget.screenHeight * 0.15,
                child: getDice(widget.diceNumber[1]),
              ),
            ]),
            const SizedBox(height: 20),
            SizedBox(
              width: widget.screenWidth * 0.3,
              height: widget.screenHeight * 0.15,
              child: getDice(widget.diceNumber[2]),
            ),
          ],
        ),
      );
    } else {
      return const SizedBox();
    }
  }

  Widget getDice(int diceNum) {
    print("isUserTurn: ${widget.isRollingUser}");
    return SvgPicture.asset(
      widget.isRollingUser
          ? 'assets/images/Dice$diceNum-roll.svg'
          : 'assets/images/Dice$diceNum.svg',
    );
  }
}
