import 'package:flutter/material.dart';
import 'package:markdownwidget/view/MdWidgetFactory.dart';
import 'package:markdown/markdown.dart' as mdparser;

import '../tags.dart';

class HeaderWidgetFactory implements MdWidgetFactory {
  @override
  Widget createMdWidget(mdparser.Node node) {
    return _generateHeadWidget(node);
  }

  Widget _generateHeadWidget(mdparser.Node node) {
    double fontSize = 16;
    double fontSizeOffset = 2;
    String tag = (node as mdparser.Element).tag.toString();
    switch (tag) {
      case h1:
        fontSize += fontSizeOffset * 6;
        break;
      case h2:
        fontSize += fontSizeOffset * 5;
        break;
      case h3:
        fontSize += fontSizeOffset * 4;
        break;
      case h4:
        fontSize += fontSizeOffset * 3;
        break;
      case h5:
        fontSize += fontSizeOffset * 2;
        break;
      case h6:
        fontSize += fontSizeOffset;
        break;
    }
    Widget widget = Container(
      alignment: Alignment.centerLeft,
      decoration: BoxDecoration(
//        color: Colors.blueGrey,
//        border: Border.fromBorderSide(BorderSide(color: Colors.white)),
      ),
      child: Text(
        node.textContent,
        style: TextStyle(
//          color: Color(0xff4A4A4A),
          fontSize: fontSize,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
    return widget;
  }
}