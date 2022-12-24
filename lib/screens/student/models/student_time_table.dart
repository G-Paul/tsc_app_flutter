import 'package:flutter/material.dart';
// import 'package:firebase_auth/firebase_auth.dart';

// import '/models/db/database.dart';

class StudentTimeTable extends StatelessWidget {
  final Map<String, dynamic> schedule;
  const StudentTimeTable({required this.schedule, super.key});

  @override
  @override
  Widget build(BuildContext context) {
    return Center(
      // child: buildDataTable(context, schedule),
      child: (schedule.isEmpty)
          ? SizedBox(
              child: CircularProgressIndicator(
                  color: Theme.of(context).primaryColor))
          : buildDataTable(context, schedule),
      // : Text(schedule['mon']['periods'][0]),
    );
  }
}

double getCellWidth(BuildContext context) {
  const double scaleFactor = 5.0;
  return MediaQuery.of(context).size.width / scaleFactor;
}

List<DataColumn> getColumns(BuildContext context, List<String> columns) =>
    columns
        .map((String column) => DataColumn(
              label: Container(
                width: getCellWidth(context),
                child: ConstrainedBox(
                  constraints: BoxConstraints(
                    maxWidth: getCellWidth(context),
                  ),
                  child: Center(
                    child: Text(
                      column,
                      style: Theme.of(context).textTheme.titleSmall!.copyWith(
                            fontSize: 17,
                            fontWeight: FontWeight.w600,
                            // decoration: TextDecoration.underline,
                            // decorationStyle: TextDecorationStyle.dotted
                          ),
                    ),
                  ),
                ),
              ),
            ))
        .toList();

List<DataCell> getCells(BuildContext context, List<String> cells) => cells
    .map((data) => DataCell(Container(
          // color: (data == "default") ? Colors.grey : Colors.brown,
          height: 50,
          width: getCellWidth(context),
          child: ConstrainedBox(
            constraints: BoxConstraints(
              maxWidth: getCellWidth(context),
            ),
            child: Center(
              child: Text((data == "default") ? "--" : data,
                  style: Theme.of(context).textTheme.bodySmall,
                  textHeightBehavior: TextHeightBehavior(
                    applyHeightToFirstAscent: false,
                    applyHeightToLastDescent: false,
                  )),
            ),
          ),
        )))
    .toList();

Widget buildDataTable(BuildContext context, Map<String, dynamic> schedule) {
  ScrollController scrollController = ScrollController();
  List<String> columns = [
    "Day",
    "P-1",
    "P-2",
    "P-3",
    "Timing",
  ];
  List<List<String>> schedule_table = getScheduleTable(schedule);

  return Container(
    margin: EdgeInsets.all(10),
    child: Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          height: 20,
          child: Center(
            child: Text(
              "Time Table",
              style: Theme.of(context).textTheme.titleLarge!.copyWith(
                  color: Theme.of(context).appBarTheme.foregroundColor,
                  fontWeight: FontWeight.bold),
            ),
          ),
        ),
        Divider(
          color: Theme.of(context).primaryColor.withOpacity(0.5),
          thickness: 1,
          indent: 40,
          endIndent: 40,
        ),
        Scrollbar(
          controller: scrollController,
          thumbVisibility: false,
          interactive: false,
          thickness: 2,
          // showTrackOnHover: true,
          // radius: Radius.circular(2),
          child: SingleChildScrollView(
            controller: scrollController,
            scrollDirection: Axis.horizontal,
            child: Padding(
              padding: const EdgeInsets.only(bottom: 8.0),
              child: DataTable(
                horizontalMargin: 0,
                // columnSpacing: MediaQuery.of(context).size.width / (5.0 * 3),
                columnSpacing: 5,
                headingTextStyle: TextStyle(
                    // leadingDistribution: TextLeadingDistribution.even,
                    ),
                border: TableBorder.all(
                  color: Theme.of(context).primaryColor.withOpacity(0.5),
                  width: 1,
                  style: BorderStyle.solid,
                ),
                columns: getColumns(context, columns),
                rows: [
                  DataRow(cells: getCells(context, schedule_table[0])),
                  DataRow(cells: getCells(context, schedule_table[1])),
                  DataRow(cells: getCells(context, schedule_table[2])),
                  DataRow(cells: getCells(context, schedule_table[3])),
                  DataRow(cells: getCells(context, schedule_table[4])),
                  DataRow(cells: getCells(context, schedule_table[5])),
                  // DataRow(cells: getCells(context, time_table_data[3])),
                ],
              ),
            ),
          ),
        ),
      ],
    ),
  );
}

List<List<String>> getScheduleTable(dynamic schedule) {
  List<List<String>> schedule_table = [
    ["Mon"],
    ["Tue"],
    ["Wed"],
    ["Thu"],
    ["Fri"],
    ["Sat"],
  ];
  schedule_table[0].addAll([
    schedule['mon']['periods'][0],
    schedule['mon']['periods'][1],
    schedule['mon']['periods'][2]
  ]);
  schedule_table[1].addAll([
    schedule['tue']['periods'][0],
    schedule['tue']['periods'][1],
    schedule['tue']['periods'][2]
  ]);
  schedule_table[2].addAll([
    schedule['wed']['periods'][0],
    schedule['wed']['periods'][1],
    schedule['wed']['periods'][2]
  ]);
  schedule_table[3].addAll([
    schedule['thu']['periods'][0],
    schedule['thu']['periods'][1],
    schedule['thu']['periods'][2]
  ]);
  schedule_table[4].addAll([
    schedule['fri']['periods'][0],
    schedule['fri']['periods'][1],
    schedule['fri']['periods'][2]
  ]);
  schedule_table[5].addAll([
    schedule['sat']['periods'][0],
    schedule['sat']['periods'][1],
    schedule['sat']['periods'][2]
  ]);

  schedule_table[0]
      .add("${schedule['mon']['start']} -\n${schedule['mon']['end']}");
  schedule_table[1]
      .add("${schedule['tue']['start']} -\n${schedule['tue']['end']}");
  schedule_table[2]
      .add("${schedule['wed']['start']} -\n${schedule['wed']['end']}");
  schedule_table[3]
      .add("${schedule['thu']['start']} -\n${schedule['thu']['end']}");
  schedule_table[4]
      .add("${schedule['fri']['start']} -\n${schedule['fri']['end']}");
  schedule_table[5]
      .add("${schedule['sat']['start']} -\n${schedule['sat']['end']}");

  // schedule_table.forEach((element) {
  //   element.forEach((ele) {
  //     if (ele.toString().compareTo("default") == 0) {
  //       ele = "-";
  //     }
  //   });
  // });

  return schedule_table;
}
