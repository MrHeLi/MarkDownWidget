import 'package:flutter/material.dart';
import 'package:markdown/markdown.dart' as mdparser;

abstract class MultiMdWidgetFactory {

  List<Widget> widgetList;

  MultiMdWidgetFactory(this.widgetList);

  /// 创建列表类型的markdown widget, 如：h1 h2....
  void createMdWidgets(mdparser.Node node);
}