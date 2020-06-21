import 'package:flutter/material.dart';

class CircleWidget extends StatelessWidget {
  CircleWidget({this.diameter}) : assert(diameter >= 0);

  double diameter;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: diameter,
      height: diameter,
      decoration: BoxDecoration(
        color: Colors.white,
        shape: BoxShape.circle,
        border: Border.all(color: Colors.black, width: 1)
      ),
    );
  }
}
