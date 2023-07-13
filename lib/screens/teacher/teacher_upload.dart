import 'package:flutter/material.dart';

class TeacherUploadScreen extends StatefulWidget {
  const TeacherUploadScreen({super.key});

  @override
  State<TeacherUploadScreen> createState() => _TeacherUploadScreenState();
}

class _TeacherUploadScreenState extends State<TeacherUploadScreen> {
  @override
  Widget build(BuildContext context) {
    return Center(child: Text("Teacher Upload Screen"),);
  }
}