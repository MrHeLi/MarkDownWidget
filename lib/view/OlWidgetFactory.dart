import 'package:flutter/material.dart';
import 'package:markdownwidget/view/MdWidgetFactory.dart';
import 'package:markdown/markdown.dart' as mdparser;

import '../tags.dart';

class OlWidgetFactory implements MdWidgetFactory {

  static const Color _contentColor = Color.fromARGB(255, 80, 80, 80);

  static const TextStyle _contentTextStyle = TextStyle(
      fontSize: 16, height: 1.3, letterSpacing: 0.2, color: _contentColor);

  int orderLevel = 1;

  List<Widget> widgets = [];

  @override
  Widget createMdWidget(mdparser.Node node) {
    widgets.clear();
    return _generateOlWidget(node);
  }

  Widget _generateOlWidget(mdparser.Node node) {
    mdparser.Element element = node as mdparser.Element;
    for (int i = 0; i < element.children.length; i++) {
      mdparser.Element child = element.children[i];
      _generateOlWidgetRecycle(child, i);
    }
    return Column(
      children: widgets,
    );
  }

  _generateOlWidgetRecycle(mdparser.Element e, int index) {
    if (e.children.length == 1 && e.children[0] is mdparser.Text) {
      _generateOlWidgetLine(e.textContent, index);
    } else if (e.children.length == 1 && e.children[0] is mdparser.Element) {
      orderLevel++;
      _generateOlWidgetRecycle(e.children[0], 0);
      orderLevel--;
    } else if (e.children.length == 2) {
      _generateOlWidgetLine(e.children[0].textContent, index);
      orderLevel++;
      _generateOlWidget(e.children[1]);
      orderLevel--;
    } else {
      orderLevel++;
      _generateOlWidget(e);
      orderLevel--;
    }
  }

  _generateOlWidgetLine(String text, int index) {
    Widget widget = Container(
        margin: EdgeInsets.only(left: 30.0 * orderLevel, top: 10.0),
        child: Row(
          verticalDirection: VerticalDirection.down,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              margin: EdgeInsets.only(right: 18.0),
              child: Text(
                (index + 1).toString() + ".",
                style: _contentTextStyle,
              ),
            ),
            Expanded(
              child: Text(text, style: _contentTextStyle),
            ),
          ],
        ));
    widgets.add(widget);
  }
}