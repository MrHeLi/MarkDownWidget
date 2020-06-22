import 'package:flutter/material.dart';
import 'package:markdownwidget/view/MdWidgetFactory.dart';
import 'package:markdownwidget/view/MultiMdWidgetFactory.dart';
import 'package:markdown/markdown.dart' as mdparser;

class TocWidgetFactory implements MdWidgetFactory {

  List<Widget> widgetList;

  TocWidgetFactory(this.widgetList) {
    assert(widgetList != null);
    _initTocTitle("目录");
  }

  void _initTocTitle(String name) {
    Widget widget = Container(
      alignment: Alignment.centerLeft,
      decoration: BoxDecoration(
//        color: Colors.blueGrey,
        border: Border.fromBorderSide(BorderSide(color: Colors.white)),
      ),
      child: Text(
        name,
        style: TextStyle(
//          color: Color(0xff4A4A4A),
          fontSize: 16,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
    widgetList.add(widget);
  }

  Widget _generateTocWidget(mdparser.Node node) {
    String hah = node.textContent;
    print(hah);
    Widget widget = Container(
      alignment: Alignment.centerLeft,
      decoration: BoxDecoration(
//        color: Colors.blueGrey,
//        border: Border.fromBorderSide(BorderSide(color: Colors.white)),
          ),
      child: Text(
        node.textContent,
        style: TextStyle(
//            color: Color(0xff4A4A4A),
          fontSize: 8,
        ),
      ),
    );
    return widget;
  }

  @override
  Widget createMdWidget(mdparser.Node node) {
    return _generateTocWidget(node);
  }
}
