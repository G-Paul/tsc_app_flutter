import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/rendering.dart';

import '/models/db/database.dart';
import '/models/widgets/customListTile.dart';
import './models/student_time_table.dart';
import './models/student_test.dart';
// import './models/student_performance_table.dart';
import 'models/student_performance.dart';

class StudentHomeScreen extends StatefulWidget {
  StudentHomeScreen({super.key});

  @override
  State<StudentHomeScreen> createState() => _StudentHomeScreenState();
}

class _StudentHomeScreenState extends State<StudentHomeScreen> {
  // final user = auth.currentUser;
  bool _expandTimeTable = false;
  bool _expandPerfTable = false;
  bool _expandTestTable = false;
  Map<String, dynamic> schedule = {};
  Map<String, dynamic> _subjects = {};
  List<Map<String, dynamic>> _tests = [];
  String? _userClass;
  String? _userCourse;

  Future<void> getStuff() async {
    final String userCourse =
        await db.collection('students').doc(user.uid).get().then((value) {
      return value.data()!['course'];
    });
    final String userClass =
        await db.collection('students').doc(user.uid).get().then((value) {
      return value.data()!['class'].toString();
    });
    final docId = "${userCourse}_$userClass";
    final sch = await UseDocument('schedule', docId).getDocument();
    //subjects
    final userSubjects =
        await db.collection('students').doc(user.uid).get().then((value) {
      return value.data()!['subjects'];
    });
    // print(userSubjects.toString());
    List<Map<String, dynamic>> tests = [];
    final testColl = db.collection('tests');
    final testQuery = await testColl
        .where('class', isEqualTo: int.parse(userClass))
        .where('course', isEqualTo: userCourse)
        .get()
        .then(
      (value) {
        return value.docs;
      },
    );
    for (var element in testQuery) {
      final testDoc = await UseDocument('tests', element.id).getDocument();
      if (!(DateTime.parse(testDoc['date']).isBefore(DateTime.now()))) {
        tests.add(testDoc);
      }
    }
    setState(() {
      schedule = sch;
      _userClass = userClass;
      _userCourse = userCourse;
      _subjects = userSubjects;
      _tests = tests;
    });
  }

  // Future<void> getTests() async {
  //   var tests = [];
  //   await GetCollection('tests', )
  // }

  @override
  void initState() {
    super.initState();
    getStuff();
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
                    BoxShadow(
                      color: (MediaQuery.of(context).platformBrightness ==
                              Brightness.dark)
                          ? Colors.white.withOpacity(0.2)
                          : Colors.white,
                      offset: Offset(-5, -5),
                      blurRadius: 5,
                      spreadRadius: 2,
                    ),
                  ],
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text(
                      "\"Develop success from failures. Discouragement and failure are two of the surest stepping stones to success.\"",
                      style: Theme.of(context).textTheme.bodySmall!.copyWith(
                            fontStyle: FontStyle.italic,
                            fontWeight: FontWeight.normal,
                            fontSize: 18,
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
                      "--Dale Carnegie",
                      textAlign: TextAlign.right,
                      style: Theme.of(context).textTheme.bodySmall!.copyWith(
                            fontWeight: FontWeight.bold,
                            color: Theme.of(context).primaryColor,
                            fontSize: 18,
                          ),
                    )
                  ],
                ),
              ),
              CustomListTile(
                leadingIcon: Icons.calendar_month,
                title: "Time Table",
                context: context,
                onTap: null,
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
                  schedule: schedule,
                  expanded: _expandTimeTable,
                ),
              ),
              CustomListTile(
                leadingIcon: Icons.auto_graph_outlined,
                title: "Performance",
                context: context,
                onTap: null,
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
                child: (_userClass == null || _userCourse == null)
                    ? Center(
                        child: LinearProgressIndicator(
                            backgroundColor: Color(0x7A9E9E9E),
                            color: Theme.of(context).primaryColor))
                    : Column(
                        children: [
                          Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                Text("Class : $_userClass",
                                    style: Theme.of(context)
                                        .textTheme
                                        .bodySmall!
                                        .copyWith(
                                            color: Theme.of(context)
                                                .textTheme
                                                .bodySmall!
                                                .color!
                                                .withOpacity(0.7))),
                                Text("Course : $_userCourse",
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
                              ? StudentPerformace(subjects: _subjects)
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
                onTapTrailing: () {},
                child: (_expandTestTable)
                    ? StudentUpcomingTests(tests: _tests)
                    : testText(_tests.length, context),
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
