import 'package:flutter/material.dart';
import './models.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class AdminHomeScreen extends StatelessWidget {
  AdminHomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: [
          // course and class drop down options

          // --------Time Table Label

          buildDataTable(context),

          // Table:
        ],
      ),
    );
  }

  List<DataColumn> getColumns(BuildContext context, List<String> columns) =>
      columns
          .map((String column) => DataColumn(
                label: Container(
                  width: MediaQuery.of(context).size.width / 4,
                  child: ConstrainedBox(
                    child: Text(
                      column,
                      style: Theme.of(context).textTheme.titleSmall,
                    ),
                    constraints: BoxConstraints(
                        maxWidth: MediaQuery.of(context).size.width / 4.0),
                  ),
                ),
              ))
          .toList();

  List<DataCell> getCells(BuildContext context, List<String> cells) => cells
      .map((data) => DataCell(Container(
            width: MediaQuery.of(context).size.width / 4.0,
            child: ConstrainedBox(
              constraints: BoxConstraints(
                  maxWidth: MediaQuery.of(context).size.width / 4.0),
              child: Text(
                data,
                style: Theme.of(context).textTheme.bodySmall,
              ),
            ),
          )))
      .toList();

  Widget buildDataTable(BuildContext context) {
    return DataTable(
      // columnSpacing: MediaQuery.of(context).size.width / (5.0 * 3),
      columnSpacing: 0,
      columns: getColumns(context, columns),
      rows: [
        DataRow(cells: getCells(context, time_table_data[0])),
        DataRow(cells: getCells(context, time_table_data[1])),
        DataRow(cells: getCells(context, time_table_data[2])),
        DataRow(cells: getCells(context, time_table_data[3])),
        DataRow(cells: getCells(context, time_table_data[4])),
        DataRow(cells: getCells(context, time_table_data[5])),
        // DataRow(cells: getCells(context, time_table_data[3])),
      ],
      
    );
  }
}
