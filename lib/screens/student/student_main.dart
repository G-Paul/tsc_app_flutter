import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:google_nav_bar/google_nav_bar.dart';

import '../navigation_drawer.dart';
import '/models/db/database.dart';

//Screens:
import './student_home.dart';
import './student_download.dart';
import './student_exam.dart';
import './student_feedback.dart';

class StudentMainScreen extends StatefulWidget {
  const StudentMainScreen({super.key});

  @override
  State<StudentMainScreen> createState() => _StudentMainScreenState();
}

class _StudentMainScreenState extends State<StudentMainScreen> {
  final List<Map<String, Object>> _pages = [
    {'page': StudentHomeScreen(), 'title': 'Student Home'},
    {'page': StudentDownloadScreen(), 'title': 'Student Download'},
    {'page': StudentExamScreen(), 'title': 'Student Exam'},
    {'page': StudentFeedbackScreen(), 'title': 'Student Feedback'},
  ];

  int _selectedPage = 0;

  void _selectPage(int index) {
    setState(() {
      _selectedPage = index;
    });
  }

  //Database stuff:
  final user = auth.currentUser;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).appBarTheme.backgroundColor,
        title: FittedBox(
          fit: BoxFit.scaleDown,
          child: Text(
            "Hello, ${user!.displayName}!",
            style: Theme.of(context).textTheme.titleLarge!.copyWith(
                color: Theme.of(context).appBarTheme.foregroundColor,
                fontWeight: FontWeight.bold),
          ),
        ),
      ),
      drawer: NavigationDrawer(),
      bottomNavigationBar: Container(
        color: Theme.of(context).backgroundColor,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 15),
          child: GNav(
            onTabChange: (value) => _selectPage(value),
            gap: 10,
            backgroundColor: Theme.of(context).backgroundColor,
            color: Theme.of(context).iconTheme.color!.withOpacity(0.9),
            activeColor: Theme.of(context).focusColor,
            tabBackgroundColor: Theme.of(context).buttonColor,
            // tabBackgroundColor: Theme.of(context).bottomAppBarColor,
            textStyle: GoogleFonts.raleway(
              fontWeight: FontWeight.bold,
              color: Theme.of(context).focusColor,
            ),
            padding: EdgeInsets.all(10),
            tabs: [
              GButton(
                icon: Icons.home_outlined,
                text: "Home",
              ),
              GButton(
                icon: Icons.download_outlined,
                text: "Download",
              ),
              GButton(
                icon: Icons.school_outlined,
                text: "Exam",
              ),
              GButton(icon: Icons.wallet, text: "Feedback"),
            ],
          ),
        ),
      ),
      body: _pages[_selectedPage]['page'] as Widget?,
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
    );
  }
}
