import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '/models/db/database.dart';
import './models/student_time_table.dart';
import './models/student_performance_table.dart';

class StudentHomeScreen extends StatefulWidget {
  StudentHomeScreen({super.key});

  @override
  State<StudentHomeScreen> createState() => _StudentHomeScreenState();
}

class _StudentHomeScreenState extends State<StudentHomeScreen> {
  // final user = auth.currentUser;
  Map<String, dynamic> schedule = {};
  Future<void> getSchedule() async {
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
    setState(() {
      schedule = sch;
    });
  }

  @override
  void initState() {
    super.initState();
    getSchedule();
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: SingleChildScrollView(
        scrollDirection: Axis.vertical,
        child: Container(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              StudentTimeTable(schedule: schedule),
              // StudentPerformaceTable(user: user),
            ],
          ),
        ),
      ),
    );
  }
}
