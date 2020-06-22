import 'package:flutter/material.dart';
import 'package:markdown/markdown.dart' as mdparser;

abstract class MdWidgetFactory {

  /// 创建单独markdown元素的widget
  Widget createMdWidget(mdparser.Node node);
}

