import 'package:flutter/material.dart';
// import './models/student_test.dart';
// import '../../models/widgets/customListTile.dart';
import 'package:tsc_app/models/widgets/customDownloadTile.dart';

class StudentExamScreen extends StatefulWidget {
  final List<Map<String, dynamic>> upcomingTests;
  final List<Map<String, dynamic>> previousTests;
  final List<Map<String, String>> previousTestSubject;
  const StudentExamScreen(
      {super.key,
      required this.upcomingTests,
      required this.previousTests,
      required this.previousTestSubject});

  @override
  State<StudentExamScreen> createState() => _StudentExamScreenState();
}

class _StudentExamScreenState extends State<StudentExamScreen> {
  String _selectedSubject = 'default';
  GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  List<Map<String, dynamic>> _displayTests = [];

  List<DropdownMenuItem<String>> get _subjectItems {
    return widget.previousTestSubject.map((item) {
      return DropdownMenuItem<String>(
        value: item['value'],
        child: Text(item['text']!),
      );
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          margin: EdgeInsets.symmetric(vertical: 15),
          padding: EdgeInsets.all(15),
          // height: 60,
          width: MediaQuery.of(context).size.width * 0.9,
          decoration: BoxDecoration(
            color: Theme.of(context).backgroundColor,
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
          child: DropdownButtonFormField<String>(
            key: _formKey,
            items: _subjectItems,
            value: _selectedSubject,
            validator: ((value) {
              return validateList(value);
            }),
            onChanged: (value) {
              // displayNotes contains only the notes of the selected subject.
              List<Map<String, dynamic>> dList = [];
              widget.previousTests.forEach((note) {
                if (note['subject'] == value!) {
                  dList.add(note);
                }
              });
              setState(() {
                _selectedSubject = value!;
                _displayTests = dList;
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
        (_displayTests.isEmpty)
            ? SizedBox(
                height: 50,
                child: Text(
                  "Please select a subject",
                  style: Theme.of(context).textTheme.bodySmall!.copyWith(
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
            itemCount: _displayTests.length,
            itemBuilder: (context, index) {
              bool showDivider = true;
              // if (index == _notes.length - 1) showDivider = false;
              String fileName = _displayTests[index]['path'].split('/').last;
              return CustomDownloadTile(
                title: _displayTests[index]['topic'],
                subtitle: fileName,
                url: _displayTests[index]['url'],
                fileName: fileName,
                showDivider: showDivider,
                showDelete: false,
              );
            },
          ),
        ),
      ],
    );
  }
}

String? validateList(String? value) {
  if (value == null || value == 'default') {
    return 'Please select a subject';
  }
  return null;
}

// Widget testText(int testLen, BuildContext context) {
//   return (testLen <= 0)
//       ? Text("No upcoming tests. YAY!!! ",
//           style: Theme.of(context).textTheme.bodySmall!.copyWith(
//               color: Theme.of(context)
//                   .textTheme
//                   .bodySmall!
//                   .color!
//                   .withOpacity(0.7)))
//       : (testLen == 1)
//           ? Text(
//               "1 UPCOMING TEST !!!",
//               style: Theme.of(context).textTheme.bodySmall!.copyWith(
//                     color: Theme.of(context).focusColor,
//                     fontWeight: FontWeight.bold,
//                   ),
//             )
//           : Text(
//               "$testLen UPCOMING TESTS !!!",
//               style: Theme.of(context).textTheme.bodySmall!.copyWith(
//                     color: Theme.of(context).focusColor,
//                     fontWeight: FontWeight.bold,
//                   ),
//             );
// }
