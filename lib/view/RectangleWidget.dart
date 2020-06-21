import 'package:flutter/material.dart';

class RectangleWidget extends StatelessWidget {
  RectangleWidget({this.diameter}) : assert(diameter >= 0);

  double diameter;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: diameter,
      height: diameter,
      decoration: BoxDecoration(
        color: Colors.black,
        shape: BoxShape.rectangle,
      ),
    );
  }
}