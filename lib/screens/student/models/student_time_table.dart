import 'package:flutter/material.dart';
// import 'package:firebase_auth/firebase_auth.dart';
// import '/models/db/database.dart';

// class StudentTimeTableSmall extends StatelessWidget {
//   final Map<String, dynamic> schedule;
//   StudentTimeTableSmall({required this.schedule, super.key});
//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       child: buildSmallDataTable(context, schedule),
//     );
//   }
// }

class StudentTimeTable extends StatelessWidget {
  final Map<String, dynamic> schedule;
  final bool expanded;
  const StudentTimeTable(
      {required this.schedule, required this.expanded, super.key});
  @override
  Widget build(BuildContext context) {
    return Center(
      // child: buildDataTable(context, schedule),
      child: (schedule.isEmpty)
          ? SizedBox(
              child: LinearProgressIndicator(
                  backgroundColor: Color(0x7A9E9E9E),
                  color: Theme.of(context).primaryColor))
          : (expanded)
              ? buildDataTable(context, schedule)
              : buildSmallDataTable(context, schedule),
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

List<DataCell> getRowCells(BuildContext context, List<String> cells) => cells
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

Widget buildSmallDataTable(
    BuildContext context, Map<String, dynamic> schedule) {
  List<List<String>> schedule_table = getScheduleTable(schedule);
  int today = DateTime.now().weekday - 1;
  String p1 = "", p2 = "", p3 = "";
  // today = DateTime.sunday - 1;
  if (today != DateTime.sunday - 1) {
    p1 = (schedule_table[today][1] == "default")
        ? "--"
        : schedule_table[today][1];
    p2 = (schedule_table[today][2] == "default")
        ? "--"
        : schedule_table[today][2];
    p3 = (schedule_table[today][3] == "default")
        ? "--"
        : schedule_table[today][3];
  }
  return SingleChildScrollView(
    scrollDirection: Axis.horizontal,
    child: (today == 6)
        ? Text("No Classes Today!!",
            style: Theme.of(context).textTheme.bodySmall!.copyWith(
                  fontSize: 15,
                  color: Theme.of(context)
                      .textTheme
                      .bodySmall!
                      .color!
                      .withOpacity(0.7),
                ))
        : Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            // mainAxisSize: MainAxisSize.min,
            children: [
              Text("P1: $p1",
                  style: Theme.of(context).textTheme.bodySmall!.copyWith(
                      fontSize: 15,
                      color: Theme.of(context)
                          .appBarTheme
                          .foregroundColor!
                          .withOpacity(0.7))),
              SizedBox(width: 20),
              Text("P2: $p2",
                  style: Theme.of(context).textTheme.bodySmall!.copyWith(
                      fontSize: 15,
                      color: Theme.of(context)
                          .appBarTheme
                          .foregroundColor!
                          .withOpacity(0.7))),
              SizedBox(width: 20),
              Text("P3: $p3",
                  style: Theme.of(context).textTheme.bodySmall!.copyWith(
                      fontSize: 15,
                      color: Theme.of(context)
                          .appBarTheme
                          .foregroundColor!
                          .withOpacity(0.7))),
              SizedBox(
                width: 20,
              ),
              Text("Time: ${schedule_table[today][4]}",
                  style: Theme.of(context).textTheme.bodySmall!.copyWith(
                      fontSize: 15,
                      color: Theme.of(context)
                          .appBarTheme
                          .foregroundColor!
                          .withOpacity(0.7)))
              // Text("lskjf"),
              // Text("lskjf"),
            ],
          ),
  );
}

Widget buildDataTable(BuildContext context, Map<String, dynamic> schedule) {
  ScrollController scrollController = ScrollController();
  List<String> columns = [
    "Day",
    "P-1",
    "P-2",
    "P-3",
    "Timing     ",
  ];
  List<List<String>> schedule_table = getScheduleTable(schedule);

  return Container(
    // margin: EdgeInsets.symmetric(vertical: 10, horizontal: 0),
    child: Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // SizedBox(
        //   height: 20,
        //   child: Center(
        //     child: Text(
        //       "Time Table",
        //       style: Theme.of(context).textTheme.titleLarge!.copyWith(
        //           color: Theme.of(context).appBarTheme.foregroundColor,
        //           fontWeight: FontWeight.bold),
        //     ),
        //   ),
        // ),
        // SizedBox(height: 10),
        // Divider(
        //   color: Theme.of(context).primaryColor.withOpacity(0.5),
        //   thickness: 0,
        //   indent: 40,
        //   endIndent: 40,
        // ),
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
                // border: TableBorder.all(
                //   color: Theme.of(context).primaryColor.withOpacity(0.5),
                //   width: 1,
                //   style: BorderStyle.solid,
                // ),
                columns: getColumns(context, columns),
                rows: [
                  DataRow(cells: getRowCells(context, schedule_table[0])),
                  DataRow(cells: getRowCells(context, schedule_table[1])),
                  DataRow(cells: getRowCells(context, schedule_table[2])),
                  DataRow(cells: getRowCells(context, schedule_table[3])),
                  DataRow(cells: getRowCells(context, schedule_table[4])),
                  DataRow(cells: getRowCells(context, schedule_table[5])),
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
      .add("${schedule['mon']['start']} -${schedule['mon']['end']}");
  schedule_table[1]
      .add("${schedule['tue']['start']} -${schedule['tue']['end']}");
  schedule_table[2]
      .add("${schedule['wed']['start']} -${schedule['wed']['end']}");
  schedule_table[3]
      .add("${schedule['thu']['start']} -${schedule['thu']['end']}");
  schedule_table[4]
      .add("${schedule['fri']['start']} -${schedule['fri']['end']}");
  schedule_table[5]
      .add("${schedule['sat']['start']} -${schedule['sat']['end']}");

  // schedule_table.forEach((element) {
  //   element.forEach((ele) {
  //     if (ele.toString().compareTo("default") == 0) {
  //       ele = "-";
  //     }
  //   });
  // });

  return schedule_table;
}
