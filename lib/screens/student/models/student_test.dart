import 'package:flutter/material.dart';
import 'package:add_2_calendar/add_2_calendar.dart';
import 'package:tsc_app/models/widgets/customDataTable.dart';

class StudentUpcomingTests extends StatelessWidget {
  final List<Map<String, dynamic>> tests;
  StudentUpcomingTests({super.key, required this.tests});

  final columns = ["Topic", "FM", "Date"];

  List<List<String>> get tableData {
    List<List<String>> res = [];
    for (var element in tests) {
      res.add([element['topic'], element['fm'].toString(), element['date']]);
    }
    return res;
  }

  void calendarAdd(List<String> row) {
    print("Calendar event will be added");
    print(row.toString());
    final Event event = Event(
      title: "TSC Test: ${row[0]}",
      description: "Talent Sprint Classes Test. All the best!",
      startDate: DateTime.parse(row[2]),
      endDate: DateTime.parse(row[2]),
      allDay: false,
    );
    Add2Calendar.addEvent2Cal(event);
  }

  @override
  Widget build(BuildContext context) {
    return CustomDataTable(
      columns: columns,
      tableData: tableData,
      scaleFactor: 3.5,
      rowFunction: calendarAdd,
    );
  }
}
