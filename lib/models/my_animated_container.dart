import 'package:dice_pt2/themes/const_themes.dart';
import 'package:flutter/material.dart';

class SizedAnimatedContainer extends StatefulWidget {
  final double width;
  //the second width is the width of the container when it is clicked
  final double secondWidth;
  final double height;
  //the second height is the height of the container when it is clicked
  final double secondHeight;
  //the child of the container
  final Widget child;
  //the text of the container shows up on the top when clicked
  //shows up in the middle when not clicked
  final Text text;
  //the duration of the animation
  final Duration duration;
  //the color of the container
  final Color boxColor;

  const SizedAnimatedContainer({
    super.key,
    required this.width,
    required this.height,
    this.secondWidth = 300,
    this.secondHeight = 300,
    required this.text,
    required this.child,
    required this.duration,
    required this.boxColor,
  });

  @override
  State<SizedAnimatedContainer> createState() => _MyContainerState();
}

class _MyContainerState extends State<SizedAnimatedContainer> {
  late double boxWidth;
  late double boxHeight;
  bool selected = true;

  @override
  void initState() {
    super.initState();
    //setting the starting width and height of the container
    boxWidth = widget.width;
    boxHeight = widget.height;
  }

  void animateBox() {
    setState(() {
      selected = !selected;
      //if the container is clicked, the width and height will be the second width and height
      boxWidth = selected ? widget.width : widget.secondWidth;
      boxHeight = selected ? widget.height : widget.secondHeight;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 15.0),
      child: GestureDetector(
        //when the container is clicked, the animateBox function will be called
        onTap: animateBox,
        child: AnimatedContainer(
          duration: widget.duration, //the duration of the animation
          width: boxWidth, //the width of the container
          height: boxHeight, //the height of the container
          decoration: constThemes.myBoxDecoration,
          child: Column(
            mainAxisAlignment:
                selected ? MainAxisAlignment.center : MainAxisAlignment.start,
            children: [
              Center(
                child: widget.text,
              ),
              if (!selected)
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: widget.child,
                ),
            ],
          ),
        ),
      ),
    );
  }
}
