import 'package:flutter/material.dart';

class ButtonWidget extends StatelessWidget {
  final Function() onTap;
  final String text;
  final double width;
  final double height;
  final Color color;
  final Color textColor;

   const ButtonWidget({super.key, required this.onTap, required this.text, required this.width, required this.height, required this.color,required this.textColor});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: height,
        width: width,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20.0),
          color: color,
        ),
        child: Center(child: Text(
          text,
          style: TextStyle(color: textColor),
        ),),
      ),
    );
  }
}
