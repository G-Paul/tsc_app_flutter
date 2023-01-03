import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';

class CustomDataTable extends StatefulWidget {
  final List<String> columns;
  final List<List<String>> tableData;
  final double scaleFactor;
  final Function? rowFunction;
  const CustomDataTable({
    super.key,
    required this.columns,
    required this.tableData,
    required this.scaleFactor,
    this.rowFunction,
  });

  @override
  State<CustomDataTable> createState() => _CustomDataTableState();
}

class _CustomDataTableState extends State<CustomDataTable> {
  final ScrollController scrollController = new ScrollController();

  List<DataRow> dataRows(BuildContext context) {
    List<DataRow> res = [];
    for (var element in widget.tableData) {
      res.add(DataRow(
          cells: getRowCells(context, element, widget.scaleFactor),
          
          onLongPress: () => (widget.rowFunction == null)
              ? null
              : widget.rowFunction!(element)));
    }
    return res;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
        child: Scrollbar(
      controller: scrollController,
      thumbVisibility: false,
      interactive: false,
      thickness: 2,
      child: SingleChildScrollView(
        controller: scrollController,
        scrollDirection: Axis.horizontal,
        child: Padding(
          padding: const EdgeInsets.only(bottom: 8.0),
          child: DataTable(
            horizontalMargin: 0,
            columnSpacing: 5,
            columns: getColumns(context, widget.columns, widget.scaleFactor),
            rows: dataRows(context),
          ),
        ),
      ),
    ));
  }
}

double getCellWidth(BuildContext context, double scaleFactor) {
  return MediaQuery.of(context).size.width / scaleFactor;
}

List<DataColumn> getColumns(
        BuildContext context, List<String> columns, double scaleFactor) =>
    columns
        .map((String column) => DataColumn(
              label: Container(
                width: getCellWidth(context, scaleFactor),
                child: ConstrainedBox(
                  constraints: BoxConstraints(
                    maxWidth: getCellWidth(context, scaleFactor),
                  ),
                  child: Center(
                    child: Text(
                      column,
                      style: Theme.of(context).textTheme.titleSmall!.copyWith(
                            fontSize: 17,
                            fontWeight: FontWeight.w600,
                            color: Theme.of(context).focusColor,
                            // decoration: TextDecoration.underline,
                            // decorationStyle: TextDecorationStyle.dotted
                          ),
                    ),
                  ),
                ),
              ),
            ))
        .toList();

List<DataCell> getRowCells(
        BuildContext context, List<String> cells, double scaleFactor) =>
    cells
        .map((data) => DataCell(Container(
              // color: (data == "default") ? Colors.grey : Colors.brown,
              height: 50,
              width: getCellWidth(context, scaleFactor),
              child: ConstrainedBox(
                constraints: BoxConstraints(
                  maxWidth: getCellWidth(context, scaleFactor),
                ),
                child: Center(
                  child: Text(
                    (data == "default") ? "--" : data,
                    style: Theme.of(context).textTheme.bodySmall,
                    // textHeightBehavior: TextHeightBehavior(
                    //   applyHeightToFirstAscent: false,
                    //   applyHeightToLastDescent: false,
                    // ),
                  ),
                ),
              ),
            )))
        .toList();
