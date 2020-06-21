import 'dart:ui';

import 'package:flutter/material.dart';
import 'dart:async';

import 'package:flutter/services.dart';
import 'package:markdownwidget/markdownwidget.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  Widget _bodyWidget;

  @override
  void initState() {
    super.initState();
    initLoading();
    initPlatformState();
  }

  Future<void> initPlatformState() async {
    MarkdownWidget markdown = new MarkdownWidget(assetPath: "assets/VR&AR.md");
    Widget markdownWidget;
    try {
      markdownWidget = await markdown.initViewWidget();
    } on PlatformException {
      print("on PlatformException");
    }

    if (!mounted) return;

    setState(() {
      _bodyWidget = markdownWidget;
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(title: Text("This is appbar")),
        body: _bodyWidget,
      ),
    );
  }

  void initLoading() {
    double windowWidth = window.physicalSize.width;
    double width = windowWidth / 40;

    _bodyWidget = Center(
        child: SizedBox(
      height: width,
      width: width,
      child: CircularProgressIndicator(),
    ));
  }
}
