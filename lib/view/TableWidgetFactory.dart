import 'package:flutter/material.dart';
import 'package:markdownwidget/view/MdWidgetFactory.dart';
import 'package:markdown/markdown.dart' as mdparser;

import '../tags.dart';

class TableWidgetFactory implements MdWidgetFactory {

  static const Color _tableGreyColor = Color.fromARGB(255, 245, 245, 245);
  static const Color _tableLineColor = Color.fromARGB(255, 224, 226, 229);

  @override
  Widget createMdWidget(mdparser.Node node) {
    return _generateTableWidget(node);
  }

  Widget _generateTableWidget(mdparser.Node node) {
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
    return widget;
  }
}