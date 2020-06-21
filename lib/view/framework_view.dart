import 'dart:ui';

import 'package:flutter/material.dart';

class FrameWorkWidget extends StatefulWidget {
  FrameWorkWidget({Key key, this.tocs, this.contents}) : super(key: key);

  List<Widget> tocs;
  List<Widget> contents;

  @override
  _FrameWorkWidgetState createState() => _FrameWorkWidgetState();
}

class _FrameWorkWidgetState extends State<FrameWorkWidget> {
  // 500 15% 2250 73% 400 12% 3150
  int contentsTableRatio; // for table of contents.
  int contentRatio; // for contents.
  int contentTocRatio; // for toc of contents.
  String url = "http://127.0.0.1:8000/blog_detail/2/";

  _FrameWorkWidgetState(
      {this.contentRatio = 73,
      this.contentsTableRatio = 15,
      this.contentTocRatio = 12});

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Row(
        children: [
          Expanded(
            flex: contentsTableRatio,
            child: Container(
//              color: Colors.pinkAccent,
            ),
          ),
          Expanded(
            flex: contentRatio,
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 80.0),
              child: ListView.builder(
//                  padding: EdgeInsets.symmetric(vertical: 100),
                  itemCount: widget.contents.length,

                  itemBuilder: (BuildContext context, int index) {
                    return widget.contents[index];
                  }),
            ),
          ),
          Expanded(
            flex: contentTocRatio,
            child: Container(
              child: Scrollbar(
                child: ListView.builder(
                    itemCount: widget.tocs.length,
                    itemExtent: 50,
                    itemBuilder: (BuildContext context, int index) {
                      return widget.tocs[index];
                    }),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
