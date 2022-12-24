import 'dart:ffi';

import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '/models/db/database.dart';

class StudentPerformaceTable extends StatefulWidget {
  final User user;
  const StudentPerformaceTable({required this.user, super.key});

  @override
  State<StudentPerformaceTable> createState() => _StudentPerformaceTableState();
}

class _StudentPerformaceTableState extends State<StudentPerformaceTable> {
  String _selectedSubject = 'eng1';
  Map<String, dynamic> _subjects = {};
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
  List<DropdownMenuItem<String>> get _subjectItems {
    return _subjectList.map((item) {
      return DropdownMenuItem<String>(
        value: item['value'],
        child: Text(item['text']!),
      );
    }).toList();
  }

  Future<void> getSubjects() async {
    print("Beginslfkjlskdjflasjflaskdfjowkjafowiejroiweorrjweojfowef");
    final userSubjects = await db
        .collection('students')
        .doc(widget.user.uid)
        .get()
        .then((value) {
      return value.data()!['subjects'];
    });
    print(userSubjects.toString());
    setState(() {
      _subjects = userSubjects;
    });
    print("Hellolskfjlkfdjslkjsflkfjsdoiwjerokjwoifjoijfew");
  }

  void initstate() {
    print("initstate called");
    // WidgetsBinding.instance.addPostFrameCallback((_) => getSubjects());
    super.initState();
    getSubjects();
  }

  @override
  Widget build(BuildContext context) {
    // getSubjects();
    return Container(
        child: Column(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        Row(
          children: [],
        ),
        Container(
          padding: EdgeInsets.symmetric(horizontal: 20, vertical: 5),
          child: DropdownButtonFormField<String>(
            key: _formKey,
            value: _selectedSubject,
            items: _subjectItems,

            validator: ((value) {
              return validateList(value!);
            }),
            style: Theme.of(context).textTheme.bodySmall,
            dropdownColor: Theme.of(context).backgroundColor,
            // hint: Text('Select Subject'),
            isExpanded: false,
            decoration: InputDecoration(
              labelText: 'Subject',
              labelStyle: Theme.of(context).textTheme.bodySmall,
              fillColor: Theme.of(context).backgroundColor,
              focusColor: Theme.of(context).primaryColor,
              enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                  borderSide: BorderSide(
                      color: Theme.of(context).primaryColor,
                      style: BorderStyle.solid)),
              focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                  borderSide: BorderSide(
                      color: Theme.of(context).primaryColor,
                      style: BorderStyle.solid)),
              border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                  borderSide: BorderSide(
                      color: Theme.of(context).primaryColor,
                      style: BorderStyle.solid)),
            ),
            menuMaxHeight: MediaQuery.of(context).size.height * 0.5,
            focusColor: Theme.of(context).primaryColor,
            onChanged: (value) {
              // _formKey.currentState!.validate();
              setState(() {
                _selectedSubject = value!;
              });
            },
          ),
        ),
        Text(
          _subjects.toString(),
          style: Theme.of(context).textTheme.bodySmall,
        ),
      ],
    ));
  }
}

String? validateList(String value) {
  if (value == 'default') {
    return 'Please select a subject';
  }
  return null;
}
