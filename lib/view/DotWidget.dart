import 'package:flutter/material.dart';

class DotWidget extends StatelessWidget {
  DotWidget({this.diameter}) : assert(diameter >= 0);

  double diameter;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: diameter,
      height: diameter,
      decoration: BoxDecoration(
        color: Colors.black,
        shape: BoxShape.circle,
      ),
    );
  }
}