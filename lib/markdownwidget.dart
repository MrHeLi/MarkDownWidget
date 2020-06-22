import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:markdownwidget/tags.dart';
import 'package:markdownwidget/view/CircleWidget.dart';
import 'package:markdownwidget/view/RectangleWidget.dart';
import 'package:markdownwidget/view/TocWidgetFactory.dart';
import 'package:markdownwidget/view/framework_view.dart';
import 'package:markdown/markdown.dart' as mdparser;

import 'view/DotWidget.dart';

class MarkdownWidget {
  MarkdownWidget({this.assetPath, this.url})
      : assert(assetPath != null || url != null),
        _tocs = [],
        _contents = [];

  final String assetPath;
  final String url;
  List<Widget> _tocs;
  List<Widget> _contents;
  static const Color _contentColor = Color.fromARGB(255, 80, 80, 80);
  static const Color _contentStrongColor = Color.fromARGB(255, 51, 51, 51);
  static const Color _tableGreyColor = Color.fromARGB(255, 245, 245, 245);
  static const Color _tableLineColor = Color.fromARGB(255, 224, 226, 229);
  static const Color _quoteTextColor = Color.fromARGB(255, 119, 119, 119);
  static const TextStyle _contentTextStyle = TextStyle(
      fontSize: 16, height: 1.3, letterSpacing: 0.2, color: _contentColor);
  int orderLevel = 1;

  static const MethodChannel _channel = const MethodChannel('markdownwidget');

  static Future<String> get platformVersion async {
    final String version = await _channel.invokeMethod('getPlatformVersion');
    return version;
  }

  void _generateTocWidget(String tag, mdparser.Node node) {
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
    _tocs.add(widget);
    _generateHeadWidget(tag, node);
  }

  void _generateHeadWidget(String tag, mdparser.Node node) {
    double fontSize = 16;
    double fontSizeOffset = 2;
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
    _contents.add(widget);
  }

  void _generateContentP(String tag, mdparser.Node node) {
    mdparser.Element element = node as mdparser.Element;
    Text text;
    if (element.children.length == 1) {
      if (element.children[0] is mdparser.Text) {
        text = Text(
          node.textContent,
          softWrap: true,
          style: TextStyle(fontSize: 16, color: _contentColor),
        );
      } else if (element.children[0] is mdparser.Element) {
        mdparser.Element imgElement = element.children[0] as mdparser.Element;
        if (imgElement.tag == img) {
          _generateImgWidget(imgElement);
          return;
        }
      }
    } else if (element.children.length > 1) {
      List<TextSpan> textSpans = [];
      for (var element in element.children) {
        if (element is mdparser.Text) {
          textSpans.add(TextSpan(text: element.text));
          continue;
        }

        if (element is mdparser.Element) {
          if (element.tag == strong) {
            textSpans.add(TextSpan(
                text: element.textContent,
                style: TextStyle(
                    color: _contentStrongColor, fontWeight: FontWeight.bold)));
          }
        }
      }

      text = Text.rich(TextSpan(
        style: TextStyle(fontSize: 16),
        children: textSpans,
      ));
    }

    Widget widget = Container(
      decoration: BoxDecoration(
//        color: Colors.blueGrey,
//        border: Border.fromBorderSide(BorderSide(color: Colors.white)),
          ),
      padding: EdgeInsets.symmetric(vertical: 10.0),
      child: text,
    );
    _contents.add(widget);
  }

  Future<void> _parse() async {
    await loadAsset().then((data) {
      final mdparser.Document document = mdparser.Document(
          extensionSet: mdparser.ExtensionSet.gitHubFlavored,
          encodeHtml: false,
          inlineSyntaxes: [TaskListSyntax()]);
      final List<String> lines = data.split(RegExp(r'\r?\n'));

      List<mdparser.Node> nodes = document.parseLines(lines);
      TocWidgetFactory tocFactory = TocWidgetFactory(_tocs);
      for (mdparser.Node node in nodes) {
        String tag = (node as mdparser.Element).tag.toString();
        print("tag: " + tag);
        switch (tag) {
          case h1:
            tocFactory.createMdWidgets(node);
            _generateHeadWidget(tag, node);
//            _generateTocWidget(tag, node);
            break;
          case h2:
//            _generateTocWidget(tag, node);
            tocFactory.createMdWidgets(node);
            _generateHeadWidget(tag, node);
            break;
          case h3:
            tocFactory.createMdWidgets(node);
            _generateHeadWidget(tag, node);
//            _generateTocWidget(tag, node);
            break;
          case h4:
//            _generateTocWidget(tag, node);
            tocFactory.createMdWidgets(node);
            _generateHeadWidget(tag, node);
            break;
          case h5:
            tocFactory.createMdWidgets(node);
            _generateHeadWidget(tag, node);
//            _generateTocWidget(tag, node);
            break;
          case h6:
            tocFactory.createMdWidgets(node);
            _generateHeadWidget(tag, node);
//            _generateTocWidget(tag, node);
            break;
          case p:
            _generateContentP(tag, node);
            break;
          case ul:
            _generateUlWidget(tag, node);
            break;
          case ol:
            _generateOlWidget(tag, node);
            break;
          case table:
            _generateTableWidget(tag, node);
            break;
          case quote:
            _generateQuoteWidget(tag, node);
            break;
        }
      }
    });
  }

  Future<Widget> initViewWidget() async {
    return await _parse().then((value) {
      return FrameWorkWidget(
        tocs: _tocs,
        contents: _contents,
      );
    });
  }

  Future<String> loadAsset() async {
    return await rootBundle.loadString(assetPath);
  }

  void _generateUlWidget(String tag, mdparser.Node node) {
    mdparser.Element element = node as mdparser.Element;
    for (int i = 0; i < element.children.length; i++) {
      mdparser.Element child = element.children[i];
      _generateUlWidgetRecycle(child, i);
    }
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
      _generateUlWidget(e.tag, e.children[1]);
      orderLevel--;
    } else {
      orderLevel++;
      _generateUlWidget(e.tag, e);
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
    _contents.add(widget);
  }

  void _generateTableWidget(String tag, mdparser.Node node) {
    mdparser.Element element = node as mdparser.Element;
    List<TableRow> tableRows = [];
    TableRow tableRow;
    element.children.forEach((e) {
      element = e as mdparser.Element;
      switch (element.tag) {
        case thead:
          List<TableCell> cells = [];
          (element.children[0] as mdparser.Element).children.forEach((e) {
            // tr
            element = e as mdparser.Element;
            TableCell cell = TableCell(
              child: Container(
                padding: EdgeInsets.all(10.0),
                child: Text(
                  element.textContent,
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
              ),
            );
            cells.add(cell);
          });
          tableRow = TableRow(
            children: cells,
            decoration: BoxDecoration(color: _tableGreyColor),
          );
          tableRows.add(tableRow);
          break;
        case tbody:
          for (int i = 0; i < element.children.length; i++) {
            mdparser.Node node = element.children[i];
            List<TableCell> cells = [];
            mdparser.Element elementRow = node as mdparser.Element;
            elementRow.children.forEach((td) {
              // row cell tr
              // td
              TableCell cell = TableCell(
                child: Container(
                  padding: EdgeInsets.all(10.0),
                  child: Text(td.textContent, style: TextStyle(fontSize: 16)),
                ),
              );
              cells.add(cell);
            });
            tableRow = TableRow(
                children: cells,
                decoration: BoxDecoration(
                  color: i.isOdd ? _tableGreyColor : Colors.white,
                ));
            tableRows.add(tableRow);
          }
          break;
      }
    });

    Widget widget = Container(
      margin: EdgeInsets.symmetric(vertical: 18.0),
      child: Table(
        border: TableBorder.all(color: _tableLineColor, width: 1),
        children: tableRows,
      ),
    );
    _contents.add(widget);
  }

  void _generateImgWidget(mdparser.Element imgElement) {
    String imgUrl = imgElement.attributes["src"];
    String alt = imgElement.attributes["alt"];
    print("imgUrl:" + imgUrl + " alt:" + alt);
    Image image = Image(
      image: NetworkImage(imgUrl),
    );
    _contents.add(image);
  }

  void _generateQuoteWidget(String tag, mdparser.Node node) {
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
        border: Border(left: BorderSide(color: _tableLineColor, width: 4)),
      ),
      child: Container(
        margin: EdgeInsets.only(left: 18.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: texts,
        ),
      ),
    );
    _contents.add(widget);
  }

  List<Widget> orderLists;

  void _generateOlWidget(String tag, mdparser.Node node) {
    mdparser.Element element = node as mdparser.Element;
    for (int i = 0; i < element.children.length; i++) {
      mdparser.Element child = element.children[i];
      _generateOlWidgetRecycle(child, i);
    }
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
      _generateOlWidget(e.tag, e.children[1]);
      orderLevel--;
    } else {
      orderLevel++;
      _generateOlWidget(e.tag, e);
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
    _contents.add(widget);
  }
}

class TaskListSyntax extends mdparser.InlineSyntax {
  // TODO：这个地方还不懂
  static final String _pattern = r'^ *\[([ xX])\] +';

  TaskListSyntax() : super(_pattern);

  @override
  bool onMatch(mdparser.InlineParser parser, Match match) {
    mdparser.Element el = mdparser.Element.withTag('input');
    el.attributes['type'] = 'checkbox';
    el.attributes['disabled'] = 'true';
    el.attributes['checked'] = '${match[1].trim().isNotEmpty}';
    parser.addNode(el);
    return true;
  }
}
