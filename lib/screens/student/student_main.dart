import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:google_nav_bar/google_nav_bar.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';

import '/models/db/database.dart';
import '../../models/nav_menu/nav_menu_button.dart';

//Screens:
import './student_home.dart';
import './student_download.dart';
import './student_exam.dart';

class StudentMainScreen extends StatefulWidget {
  const StudentMainScreen({super.key});

  @override
  State<StudentMainScreen> createState() => _StudentMainScreenState();
}

class _StudentMainScreenState extends State<StudentMainScreen> {
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
  List<Map<String, dynamic>> _downloadNotes = [];
  late int _userClass;
  String? _userCourse;
  int _mileStone = 0;
  bool _isLoading = true;
  bool _showContent = false;

  int _selectedPage = 0;
  void _selectPage(int index) {
    setState(() {
      _selectedPage = index;
    });
  }

  //Database Stuff
  Future<void> getStuff() async {
    setState(() {
      _isLoading = true;
      _showContent = false;
    });
    //MILESTONE 1: Get student details from the student doc (class, course, subjects)
    await db.collection('students').doc(user.uid).get().then((value) {
      setState(() {
        _userCourse = value.data()!['course'];
        _userClass = value.data()!['class'];
        _subjects = value.data()!['subjects'];
        _mileStone++;
      });
    });
    //MILESTONE 2: Make the list of subjects for which the data is available
    List<Map<String, String>> presentSubList = [
      {"value": 'default', "text": 'Select Subject'}
    ];
    _subjects.forEach((key, value) {
      presentSubList.add(_subjectList.firstWhere((element) {
        return element['value'] == key;
      }));
    });
    setState(() {
      _presentSubjectsPerformance = presentSubList;
      _mileStone++;
    });
    //MILESTONE 3: Get the Schedule for the current user
    final docId = "${_userCourse}_$_userClass";
    final schedule = await UseDocument('schedule', docId).getDocument();
    setState(() {
      _schedule = schedule;
      _mileStone++;
    });
    //MILESTONE 4: Get the tests (upcoming and previous):
    List<Map<String, dynamic>> upcomingTests = [];
    List<Map<String, dynamic>> previousTests = [];
    final testColl = db.collection('tests');
    final testQuery = await testColl
        .where('class', isEqualTo: _userClass)
        .where('course', isEqualTo: _userCourse)
        .get()
        .then(
      (value) {
        return value.docs;
      },
    );
    for (var element in testQuery) {
      final testDoc = await UseDocument('tests', element.id).getDocument();
      if (!(DateTime.parse(testDoc['date']).isBefore(DateTime.now()))) {
        upcomingTests.add(testDoc);
      } else {
        previousTests.add(testDoc);
      }
    }
    setState(() {
      _previousTests = previousTests;
      _upcomingTests = upcomingTests;
      _mileStone++;
    });
    //MILESTONE 5: Get the download notes list
    List<Map<String, dynamic>> notes = [];
    final notesColl = db.collection('notes');
    final notesQuery = await notesColl
        .where('class', isEqualTo: _userClass)
        .where('course', isEqualTo: _userCourse)
        .get()
        .then(
      (value) {
        return value.docs;
      },
    );
    for (var element in notesQuery) {
      final testDoc = await UseDocument('notes', element.id).getDocument();
      notes.add(testDoc);
      // print(testDoc.toString());
    }
    setState(() {
      _downloadNotes = notes;
      _mileStone++;
    });
    // MILESTONE 6: Make the subject list for downloads
    List<Map<String, String>> presentList = [
      {"value": 'default', "text": 'Select Subject'}
    ];
    _downloadNotes.forEach((note) {
      if (!presentList.any((subject) {
        return subject['value'] == note['subject'];
      })) {
        presentList.add(_subjectList.firstWhere((element) {
          return element['value'] == note['subject'];
        }));
      }
    });
    setState(() {
      _presentSubjectsDownloads = presentList;
      _mileStone++;
      _isLoading = false;
    });
  }

  @override
  void initState() {
    getStuff();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: (_showContent)
          ? AppBar(
              backgroundColor: Theme.of(context).appBarTheme.backgroundColor,
              title: FittedBox(
                fit: BoxFit.scaleDown,
                child: Text(
                  "Hello, ${user.displayName}!",
                  style: Theme.of(context).textTheme.titleLarge!.copyWith(
                      color: Theme.of(context).appBarTheme.foregroundColor,
                      fontWeight: FontWeight.bold),
                ),
              ),
              actions: [
                NavMenuButton(),
              ],
            )
          : null,
      // drawer: NavigationDrawer(),
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
                      icon: Icons.download_outlined,
                      text: "Downloads",
                    ),
                    GButton(
                      icon: Icons.school_outlined,
                      text: "Tests",
                    ),
                    // GButton(icon: Icons.wallet, text: "Feedback"),
                  ],
                ),
              ),
            )
          : SizedBox(),
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
              ? StudentHomeScreen(
                  userClass: _userClass,
                  userCourse: _userCourse,
                  schedule: _schedule,
                  subjects: _subjects,
                  upcomingTests: _upcomingTests,
                  presentSubjectList: _presentSubjectsPerformance,
                )
              : (_selectedPage == 1)
                  ? StudentDownloadScreen(
                      notes: _downloadNotes,
                      presentSubjectList: _presentSubjectsDownloads,
                    )
                  : StudentExamScreen(),
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
    );
  }
}
