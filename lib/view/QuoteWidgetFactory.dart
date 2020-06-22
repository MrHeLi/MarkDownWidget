import 'package:flutter/material.dart';
import 'package:markdownwidget/view/MdWidgetFactory.dart';
import 'package:markdown/markdown.dart' as mdparser;

class QuoteWidgetFactory implements MdWidgetFactory {

  static const Color _quoteTextColor = Color.fromARGB(255, 119, 119, 119);

  static const Color _preLineColor = Color.fromARGB(255, 224, 226, 229);

  @override
  Widget createMdWidget(mdparser.Node node) {
    return _generateQuoteWidget(node);
  }

  Widget _generateQuoteWidget(mdparser.Node node) {
    mdparser.Element element = node as mdparser.Element;
    List<Text> texts = [];
    element.children.forEach((e) {
      mdparser.Element elementP = e as mdparser.Element;
      Text text = Text(
        elementP.textContent,
        style: TextStyle(color: _quoteTextColor),
      );
      texts.add(text);
    });

    Widget widget = Container(
      margin: EdgeInsets.symmetric(vertical: 18.0),
      decoration: BoxDecoration(
        border: Border(left: BorderSide(color: _preLineColor, width: 4)),
      ),
      child: Container(
        margin: EdgeInsets.only(left: 18.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: texts,
        ),
      ),
    );
    return widget;
  }
}