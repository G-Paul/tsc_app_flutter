import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:google_nav_bar/google_nav_bar.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';
import 'package:tsc_app/screens/teacher/teacher_exam.dart';
import 'package:tsc_app/screens/teacher/teacher_home.dart';
import 'package:tsc_app/screens/teacher/teacher_upload.dart';


import '/models/db/database.dart';
import '../../models/nav_menu/nav_menu_button.dart';

class TeacherMainScreen extends StatefulWidget {
  const TeacherMainScreen({super.key});

  @override
  State<TeacherMainScreen> createState() => _TeacherMainScreenState();
}

class _TeacherMainScreenState extends State<TeacherMainScreen> {

    final _subjectList = [
    {"value": 'default', "text": 'Select Subject'},
    {"value": 'eng1', "text": 'English 1'},
    {"value": 'eng2', "text": 'English 2'},
    {"value": 'odia', "text": 'Odia'},
    {"value": 'hindi', "text": 'Hindi'},
    {"value": 'math', "text": 'Mathematics'},
    {"value": 'comp', "text": 'Computers'},
    {"value": 'sci', "text": 'Science'},
    {"value": 'phys', "text": 'Physics'},
    {"value": 'chem', "text": 'Chemistry'},
    {"value": 'bio', "text": 'Biology'},
    {"value": 'sst', "text": 'Social Science'},
    {"value": 'hist', "text": 'History'},
    {"value": 'geo', "text": 'Geography'}
  ];

  Map<String, dynamic> _schedule = {};
  Map<String, dynamic> _subjects = {};
  List<Map<String, dynamic>> _upcomingTests = [];
  List<Map<String, dynamic>> _previousTests = [];
  List<Map<String, String>> _presentSubjectsPerformance = [];
  List<Map<String, String>> _presentSubjectsDownloads = [];
  List<Map<String, String>> _presentSubjectsTests = [];
  List<Map<String, dynamic>> _downloadNotes = [];
  late int _userClass;
  String? _userCourse;
  String? _userName;
  int _mileStone = 0;
  bool _isLoading = true;
  bool _showContent = false;

  int _selectedPage = 0;
  void _selectPage(int index) {
    setState(() {
      _selectedPage = index;
    });
  }

  Future<void> getStuff() async {
    setState(() {
      _isLoading = true;
      _showContent = false;
    });
    //MILESTONE 1: Get student details from the student doc (class, course, subjects)
    await db.collection('teachers').doc(user.uid).get().then((value) {
      setState(() {
        _userName = value.data()!['name'];
        _mileStone++;
      });
    });


    // Complete: Set loading to false
    setState(() {
      // _presentSubjectsDownloads = presentList;
      _mileStone++;
      _isLoading = false;
      _showContent = true; //---------------------need to change this later
    });
  }

  @override
  void initState() {
    super.initState();
    getStuff();
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: (_showContent)
          ? AppBar(
              backgroundColor: Theme.of(context).appBarTheme.backgroundColor,
              title: FittedBox(
                fit: BoxFit.scaleDown,
                child: Text(
                  "Hello, $_userName!",
                  style: Theme.of(context).textTheme.titleLarge!.copyWith(
                      color: Theme.of(context).appBarTheme.foregroundColor,
                      fontWeight: FontWeight.bold),
                ),
              ),
              actions: [
                NavMenuButton(userType: "Teacher", userClass: null, userCourse: null),
              ],
            )
          : null,
      bottomNavigationBar: (_showContent)
          ? Container(
              color: Theme.of(context).scaffoldBackgroundColor,
              child: Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 15, vertical: 15),
                child: GNav(
                  onTabChange: (value) => _selectPage(value),
                  gap: 10,
                  backgroundColor: Theme.of(context).scaffoldBackgroundColor,
                  color: Theme.of(context).iconTheme.color!.withOpacity(0.9),
                  activeColor: Colors.white,
                  tabBackgroundColor: Theme.of(context).buttonColor,
                  // tabBackgroundColor: Theme.of(context).bottomAppBarColor,
                  textStyle: GoogleFonts.raleway(
                    fontWeight: FontWeight.bold,
                    fontSize: 17,
                    color: Colors.white,
                  ),
                  padding: EdgeInsets.all(10),
                  tabs: [
                    GButton(
                      icon: Icons.home_outlined,
                      text: "Home",
                    ),
                    GButton(
                      icon: Icons.upload_outlined,
                      text: "Uploads",
                    ),
                    GButton(
                      icon: Icons.school_outlined,
                      text: "Tests",
                    ),
                    // GButton(
                    //   icon: Icons.check_box_outlined,
                    //   text: "To Do",
                    // ),
                    // GButton(icon: Icons.wallet, text: "Feedback"),
                  ],
                ),
              ),
            )
            :SizedBox(),
      body: (!_showContent)
          ? Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  CircularPercentIndicator(
                    radius: MediaQuery.of(context).size.width * 0.25,
                    lineWidth: 15,
                    percent: (_mileStone / 6.0),
                    // percent: 0.6,
                    progressColor: Theme.of(context).primaryColor,
                    circularStrokeCap: CircularStrokeCap.round,
                    animation: true,
                    animateFromLastPercent: true,
                    animationDuration: 200,
                    onAnimationEnd: (() {
                      if (!_isLoading) {
                        setState(() {
                          _showContent = true;
                        });
                      }
                    }),
                    backgroundColor:
                        Theme.of(context).primaryColor.withOpacity(0.15),
                    center: Text(
                      "${(_mileStone * 100 / 6).toInt()}%",
                      style: Theme.of(context).textTheme.titleLarge!.copyWith(
                            fontSize: 30,
                            fontWeight: FontWeight.bold,
                          ),
                    ),
                  ),
                  SizedBox(height: MediaQuery.of(context).size.width * 0.1),
                  Text(
                    "Loading...",
                    style: Theme.of(context).textTheme.titleLarge,
                  ),
                ],
              ),
            )
          : (_selectedPage == 0)
              ? TeacherHomeScreen()
              : (_selectedPage == 1)
                  ? TeacherUploadScreen()
                  : TeacherExamScreen(),
    );
  }
}