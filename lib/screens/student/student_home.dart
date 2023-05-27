import 'dart:math';

import 'package:flutter/material.dart';
import '/models/widgets/customListTile.dart';
import './models/student_time_table.dart';
import './models/student_test.dart';
import 'models/student_performance.dart';
import '../../models/dummy/dummy_quotes.dart';

class StudentHomeScreen extends StatefulWidget {
  final Map<String, dynamic> schedule;
  final Map<String, dynamic> subjects;
  final List<Map<String, dynamic>> upcomingTests;
  final List<Map<String, String>> presentSubjectList;
  final int userClass;
  final String? userCourse;
  StudentHomeScreen(
      {super.key,
      required this.userClass,
      required this.userCourse,
      required this.schedule,
      required this.subjects,
      required this.presentSubjectList,
      required this.upcomingTests});

  @override
  State<StudentHomeScreen> createState() => _StudentHomeScreenState();
}

class _StudentHomeScreenState extends State<StudentHomeScreen> {
  // final user = auth.currentUser;
  bool _expandTimeTable = false;
  bool _expandPerfTable = false;
  bool _expandTestTable = false;
  String _currentQuote = "";
  String _currentAuthor = "";

  @override
  void initState() {
    super.initState();
    final random = Random();
    final index = random.nextInt(dummyQuotes.length);
    setState(() {
      _currentQuote = dummyQuotes[index]["quote"]!;
      _currentAuthor = dummyQuotes[index]["author"]!;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: SingleChildScrollView(
        scrollDirection: Axis.vertical,
        child: Container(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Container(
                // height: 120,
                width: MediaQuery.of(context).size.width * 0.9,
                margin: EdgeInsets.symmetric(vertical: 15),
                padding: EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: Theme.of(context).scaffoldBackgroundColor,
                  borderRadius: BorderRadius.circular(12),
                  boxShadow: [
                    // For neumorphism
                    BoxShadow(
                      color: (MediaQuery.of(context).platformBrightness ==
                              Brightness.dark)
                          ? Colors.black
                          : Colors.black.withOpacity(0.3),
                      offset: Offset(5, 5),
                      blurRadius: 5,
                      spreadRadius: 1,
                    ),
                    // BoxShadow(
                    //   color: (MediaQuery.of(context).platformBrightness ==
                    //           Brightness.dark)
                    //       ? Colors.white.withOpacity(0.2)
                    //       : Colors.white,
                    //   offset: Offset(-5, -5),
                    //   blurRadius: 5,
                    //   spreadRadius: 2,
                    // ),
                  ],
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text(
                      _currentQuote,
                      style: Theme.of(context).textTheme.bodySmall!.copyWith(
                            fontStyle: FontStyle.italic,
                            fontWeight: FontWeight.normal,
                            fontSize: 16,
                            color: Theme.of(context)
                                .textTheme
                                .bodySmall!
                                .color!
                                .withOpacity(0.8),
                          ),
                      textAlign: TextAlign.start,
                      softWrap: true,
                    ),
                    SizedBox(height: 10),
                    Text(
                      "--$_currentAuthor",
                      textAlign: TextAlign.right,
                      style: Theme.of(context).textTheme.bodySmall!.copyWith(
                            fontWeight: FontWeight.bold,
                            color: Theme.of(context).primaryColor,
                            fontSize: 16,
                          ),
                    )
                  ],
                ),
              ),
              CustomListTile(
                leadingIcon: Icons.calendar_month,
                title: "Time Table",
                context: context,
                onTap: () {
                  setState(() {
                    _expandTimeTable = !_expandTimeTable;
                  });
                },
                onTapTrailing: () {
                  setState(() {
                    _expandTimeTable = !_expandTimeTable;
                  });
                },
                trailing: (_expandTimeTable)
                    ? Icon(Icons.expand_less,
                        color: Theme.of(context).focusColor)
                    : Icon(Icons.expand_more,
                        color: Theme.of(context).focusColor),
                child: StudentTimeTable(
                  schedule: widget.schedule,
                  expanded: _expandTimeTable,
                ),
              ),
              CustomListTile(
                leadingIcon: Icons.auto_graph_outlined,
                title: "Performance",
                context: context,
                onTap: () {
                  setState(() {
                    _expandPerfTable = !_expandPerfTable;
                  });
                },
                onTapTrailing: () {
                  setState(() {
                    _expandPerfTable = !_expandPerfTable;
                  });
                },
                trailing: (_expandPerfTable)
                    ? Icon(Icons.expand_less,
                        color: Theme.of(context).focusColor)
                    : Icon(Icons.expand_more,
                        color: Theme.of(context).focusColor),
                child: Column(
                  children: [
                    Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          Text("Class : ${widget.userClass}",
                              style: Theme.of(context)
                                  .textTheme
                                  .bodySmall!
                                  .copyWith(
                                      color: Theme.of(context)
                                          .textTheme
                                          .bodySmall!
                                          .color!
                                          .withOpacity(0.7))),
                          Text("Course : ${widget.userCourse}",
                              style: Theme.of(context)
                                  .textTheme
                                  .bodySmall!
                                  .copyWith(
                                      color: Theme.of(context)
                                          .textTheme
                                          .bodySmall!
                                          .color!
                                          .withOpacity(0.7))),
                        ]),
                    (_expandPerfTable)
                        ? SizedBox(height: 15)
                        : SizedBox(
                            height: 0,
                            width: 0,
                          ),
                    (_expandPerfTable)
                        ? StudentPerformace(
                            subjects: widget.subjects,
                            presentSubjectList: widget.presentSubjectList,
                          )
                        : SizedBox(
                            height: 0,
                            width: 0,
                          ),
                  ],
                ),
              ),
              CustomListTile(
                leadingIcon: Icons.checklist_rounded,
                title: "Upcoming Tests",
                trailing: (_expandTestTable)
                    ? Icon(Icons.expand_less,
                        color: Theme.of(context).focusColor)
                    : Icon(Icons.expand_more,
                        color: Theme.of(context).focusColor),
                context: context,
                onTap: () {
                  setState(() {
                    _expandTestTable = !_expandTestTable;
                  });
                },
                onTapTrailing: () {
                  setState(() {
                    _expandTestTable = !_expandTestTable;
                  });
                },
                child: (_expandTestTable)
                    ? StudentUpcomingTests(tests: widget.upcomingTests)
                    : testText(widget.upcomingTests.length, context),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

Widget testText(int testLen, BuildContext context) {
  return (testLen <= 0)
      ? Text("No upcoming tests. YAY!!! ",
          style: Theme.of(context).textTheme.bodySmall!.copyWith(
              color: Theme.of(context)
                  .textTheme
                  .bodySmall!
                  .color!
                  .withOpacity(0.7)))
      : (testLen == 1)
          ? Text(
              "1 UPCOMING TEST !!!",
              style: Theme.of(context).textTheme.bodySmall!.copyWith(
                    color: Theme.of(context).focusColor,
                    fontWeight: FontWeight.bold,
                  ),
            )
          : Text(
              "$testLen UPCOMING TESTS !!!",
              style: Theme.of(context).textTheme.bodySmall!.copyWith(
                    color: Theme.of(context).focusColor,
                    fontWeight: FontWeight.bold,
                  ),
            );
}
