import 'package:flutter/material.dart';
import 'package:markdownwidget/view/MdWidgetFactory.dart';
import 'package:markdown/markdown.dart' as mdparser;

import '../tags.dart';
import 'CircleWidget.dart';
import 'DotWidget.dart';
import 'RectangleWidget.dart';

class UlWidgetFactory implements MdWidgetFactory {

  static const Color _contentColor = Color.fromARGB(255, 80, 80, 80);

  static const TextStyle _contentTextStyle = TextStyle(
      fontSize: 16, height: 1.3, letterSpacing: 0.2, color: _contentColor);

  int orderLevel = 1;

  List<Widget> widgets = [];

  @override
  Widget createMdWidget(mdparser.Node node) {
    widgets.clear();
    return _generateUlWidget(node);
  }

  Widget _generateUlWidget(mdparser.Node node) {
    mdparser.Element element = node as mdparser.Element;
    for (int i = 0; i < element.children.length; i++) {
      mdparser.Element child = element.children[i];
      _generateUlWidgetRecycle(child, i);
    }
    return Column(
      children: widgets,
    );
  }

  _generateUlWidgetRecycle(mdparser.Element e, int index) {
    if (e.children.length == 1 && e.children[0] is mdparser.Text) {
      _generateUlWidgetLine(e.textContent);
    } else if (e.children.length == 1 && e.children[0] is mdparser.Element) {
      orderLevel++;
      _generateUlWidgetRecycle(e.children[0], 0);
      orderLevel--;
    } else if (e.children.length == 2) {
      _generateUlWidgetLine(e.children[0].textContent);
      orderLevel++;
      _generateUlWidget(e.children[1]);
      orderLevel--;
    } else {
      orderLevel++;
      _generateUlWidget(e);
      orderLevel--;
    }
  }

  void _generateUlWidgetLine(String text) {
    Widget preDotWidget;
    if (orderLevel == 1) {
      preDotWidget = DotWidget(diameter: 7,);
    } else if (orderLevel == 2) {
      preDotWidget = CircleWidget(diameter: 7,);
    } else {
      preDotWidget = RectangleWidget(diameter: 7,);
    }
    Widget widget = Container(
        margin: EdgeInsets.only(left: 30.0 * orderLevel, top: 10.0),
        child: Row(
          verticalDirection: VerticalDirection.down,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Container(
              margin: EdgeInsets.only(right: 16, top: 6),
              child: preDotWidget,
            ),
            Container(
              child: Expanded(
                flex: 1,
                child: Text(text, softWrap: true, style: _contentTextStyle),
              ),
            )
          ],
        ));
    widgets.add(widget);
  }
}