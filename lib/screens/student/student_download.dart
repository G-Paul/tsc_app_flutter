import 'package:flutter/material.dart';
import 'package:tsc_app/models/db/database.dart';
import 'package:tsc_app/models/widgets/customListTile.dart';
import 'package:tsc_app/models/widgets/customDownloadTile.dart';

class StudentDownloadScreen extends StatefulWidget {
  const StudentDownloadScreen({super.key});

  @override
  State<StudentDownloadScreen> createState() => _StudentDownloadScreenState();
}

class _StudentDownloadScreenState extends State<StudentDownloadScreen> {
  bool isLoading = false;
  List<Map<String, dynamic>> _notes = [];
  List<Map<String, dynamic>> _displayNotes = [];
  String _selectedSubject = 'default';
  List<Map<String, String>> _presentSubjectList = [];
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
  GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  void getNotes() async {
    setState(() {
      isLoading = true;
    });
    final String userCourse =
        await db.collection('students').doc(user.uid).get().then((value) {
      return value.data()!['course'];
    });
    final String userClass =
        await db.collection('students').doc(user.uid).get().then((value) {
      return value.data()!['class'].toString();
    });
    List<Map<String, dynamic>> notes = [];
    final notesColl = db.collection('notes');
    final notesQuery = await notesColl
        .where('class', isEqualTo: int.parse(userClass))
        .where('course', isEqualTo: userCourse)
        .get()
        .then(
      (value) {
        return value.docs;
      },
    );
    for (var element in notesQuery) {
      final testDoc = await UseDocument('notes', element.id).getDocument();
      notes.add(testDoc);
      print(testDoc.toString());
    }
    List<Map<String, String>> presentList = [
      {"value": 'default', "text": 'Select Subject'}
    ];
    notes.forEach((note) {
      if (!presentList.any((subject) {
        return subject['value'] == note['subject'];
      })) {
        presentList.add(_subjectList.firstWhere((element) {
          return element['value'] == note['subject'];
        }));
      }
    });
    // print("sodfjlasdjflsdjlfjdsofjlkdsjfowejroijewoirjokwjfoijewf");
    // print("${userClass}_${userCourse} ");
    // print(notes);
    setState(() {
      _notes = notes;
      _presentSubjectList = presentList;
      isLoading = false;
    });
  }

  List<DropdownMenuItem<String>> get _subjectItems {
    return _presentSubjectList.map((item) {
      return DropdownMenuItem<String>(
        value: item['value'],
        child: Text(item['text']!),
      );
    }).toList();
  }

  void getPresentSubjectList(
      Map<String, dynamic> subjects, List<Map<String, String>> subjectList) {
    List<Map<String, String>> presentSubList = [
      {"value": 'default', "text": 'Select Subject'}
    ];
    subjects.forEach((key, value) {
      presentSubList.add(subjectList.firstWhere((element) {
        return element['value'] == key;
      }));
    });
    print(presentSubList.toString());
    setState(() {
      _presentSubjectList = presentSubList;
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getNotes();
    setState(() {
      _presentSubjectList = _subjectList;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      //select screen
      child: (isLoading)
          ? Center(
              child: SizedBox(
                height: 40,
                width: 40,
                child: CircularProgressIndicator(
                  color: Theme.of(context).primaryColor,
                ),
              ),
            )
          : Column(
              children: [
                Container(
                  // child: DropdownButtonFormField<String>(
                  margin: EdgeInsets.symmetric(vertical: 15),
                  padding: EdgeInsets.all(15),
                  // height: 60,
                  width: MediaQuery.of(context).size.width * 0.9,
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
                  child: DropdownButtonFormField<String>(
                    key: _formKey,
                    items: _subjectItems,
                    value: _selectedSubject,
                    validator: ((value) {
                      return validateList(value);
                    }),
                    onChanged: (value) {
                      List<Map<String, dynamic>> dList = [];
                      _notes.forEach((note) {
                        if (note['subject'] == value!) {
                          dList.add(note);
                        }
                      });
                      setState(() {
                        _selectedSubject = value!;
                        _displayNotes = dList;
                      });
                    }, // onchanged
                    style: Theme.of(context).textTheme.bodySmall,
                    dropdownColor: Theme.of(context).backgroundColor,
                    // hint: Text('Select Subject'),
                    isExpanded: true,
                    decoration: InputDecoration(
                      labelText: 'Subject',
                      labelStyle: Theme.of(context).textTheme.bodySmall,
                      fillColor: Theme.of(context).backgroundColor,
                      focusColor: Theme.of(context).primaryColor,
                      enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                          borderSide: BorderSide(
                              color: Theme.of(context).primaryColor,
                              width: 2,
                              style: BorderStyle.solid)),
                      focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                          borderSide: BorderSide(
                              color: Theme.of(context).primaryColor,
                              width: 2,
                              style: BorderStyle.solid)),
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                          borderSide: BorderSide(
                              width: 2,
                              color: Theme.of(context).primaryColor,
                              style: BorderStyle.solid)),
                    ),
                    menuMaxHeight: MediaQuery.of(context).size.height * 0.5,
                    focusColor: Theme.of(context).primaryColor,
                  ),
                ),
                (_displayNotes.isEmpty)
                    ? SizedBox(
                        height: 50,
                        child: Text(
                          "Please select a subject",
                          style:
                              Theme.of(context).textTheme.bodySmall!.copyWith(
                                    color: Theme.of(context).errorColor,
                                    fontSize: 15,
                                    fontWeight: FontWeight.bold,
                                  ),
                        ),
                      )
                    : Divider(
                        height: 2,
                        color: Theme.of(context).primaryColor.withOpacity(0.7),
                      ),
                Expanded(
                  child: ListView.builder(
                    itemCount: _displayNotes.length,
                    itemBuilder: (context, index) {
                      bool showDivider = true;
                      // if (index == _notes.length - 1) showDivider = false;
                      String fileName =
                          _displayNotes[index]['path'].split('/').last;
                      return CustomDownloadTile(
                        title: _displayNotes[index]['topic'],
                        subtitle: fileName,
                        url: _displayNotes[index]['url'],
                        fileName: fileName,
                        showDivider: showDivider,
                        showDelete: false,
                      );
                    },
                  ),
                ),
              ],
            ),
    );
  }
}

String? validateList(String? value) {
  if (value == null || value == 'default') {
    return 'Please select a subject';
  }
  return null;
}
