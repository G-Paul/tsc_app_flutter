import 'package:flutter/material.dart';

class TeacherExamScreen extends StatefulWidget {
  const TeacherExamScreen({super.key});

  @override
  State<TeacherExamScreen> createState() => _TeacherExamScreenState();
}

class _TeacherExamScreenState extends State<TeacherExamScreen> {
  @override
  Widget build(BuildContext context) {
    return Center(child: Text("Teacher Exam Screen"),);
  }
}