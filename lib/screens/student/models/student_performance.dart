import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';

import 'package:tsc_app/models/widgets/customDataTable.dart';

class StudentPerformace extends StatefulWidget {
  final Map<String, dynamic> subjects;
  const StudentPerformace({
    super.key,
    required this.subjects,
  });
  // static const routeName = '/studentPerformance';

  @override
  State<StudentPerformace> createState() => _StudentPerformaceState();
}

class _StudentPerformaceState extends State<StudentPerformace> {
  String _selectedSubject = 'default';
  Map<String, dynamic> _subjects = {};
  List<Map<String, dynamic>> _selectedData = [];
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

  final columns = ["Topic", "Date", "Marks"];
  GlobalKey<FormState> _formKey = GlobalKey<FormState>();


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

  void getSelectedSubData(Map<String, dynamic> subjects, String subject) {
    List<Map<String, dynamic>> selectedSubData = [
      // {'key': 'hello'}
    ];
    if (subjects[subject] != null) {
      subjects[subject].forEach((element) {
        selectedSubData.add(element as Map<String, dynamic>);
      });
    }
    setState(() {
      _selectedData = selectedSubData;
    });
  }

  List<List<String>> tableData(List<Map<String, dynamic>> selectedData) {
    List<List<String>> tableData = [];
    selectedData.forEach(((element) {
      if (element['marked']) {
        tableData.add([
          element['topic'],
          element['date'],
          "${element['mark']} / ${element['fm']}"
        ]);
      }
    }));
    return tableData;
  }

  @override
  Widget build(BuildContext context) {
    // final _args =
    //     ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>;
    setState(() {
      _subjects = widget.subjects;
    });
    getPresentSubjectList(_subjects, _subjectList);
    return Container(
      child: Column(
        children: [
          //
          Container(
            // width: MediaQuery.of(context).size.width * 0.7,
            padding: EdgeInsets.symmetric(horizontal: 20, vertical: 5),
            child: DropdownButtonFormField<String>(
              key: _formKey,
              value: _selectedSubject,
              items: _subjectItems,
              validator: ((value) {
                return validateList(value);
              }),

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
              onChanged: (value) {
                // _formKey.currentState!.validate();
                setState(() {
                  _selectedSubject = value!;
                });
                getSelectedSubData(_subjects, _selectedSubject);
              },
            ),
          ),
          (!_selectedData.isEmpty)
              // ? buildDataTable(context, _selectedData)
              ? CustomDataTable(
                  columns: columns,
                  tableData: tableData(_selectedData),
                  scaleFactor: 3)
              : SizedBox(
                  height: 50,
                  child: Text(
                    "Please select a subject",
                    style: Theme.of(context).textTheme.bodySmall!.copyWith(
                          color: Theme.of(context).errorColor,
                          fontSize: 15,
                          fontWeight: FontWeight.bold,
                        ),
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

// double getCellWidth(BuildContext context) {
//   const double scaleFactor = 3.0;
//   return MediaQuery.of(context).size.width / scaleFactor;
// }

// List<DataColumn> getColumns(BuildContext context, List<String> columns) =>
//     columns
//         .map((String column) => DataColumn(
//               label: Container(
//                 width: getCellWidth(context),
//                 child: ConstrainedBox(
//                   constraints: BoxConstraints(
//                     maxWidth: getCellWidth(context),
//                   ),
//                   child: Center(
//                     child: Text(
//                       column,
//                       style: Theme.of(context).textTheme.titleSmall!.copyWith(
//                             fontSize: 17,
//                             fontWeight: FontWeight.w600,
//                             color: Theme.of(context).focusColor,
//                             // decoration: TextDecoration.underline,
//                             // decorationStyle: TextDecorationStyle.dotted
//                           ),
//                     ),
//                   ),
//                 ),
//               ),
//             ))
//         .toList();

// List<DataCell> getRowCells(BuildContext context, List<String> cells) => cells
//     .map((data) => DataCell(Container(
//           // color: (data == "default") ? Colors.grey : Colors.brown,
//           height: 50,
//           width: getCellWidth(context),
//           child: ConstrainedBox(
//             constraints: BoxConstraints(
//               maxWidth: getCellWidth(context),
//             ),
//             child: Center(
//               child: Text((data == "default") ? "--" : data,
//                   style: Theme.of(context).textTheme.bodySmall,
//                   textHeightBehavior: TextHeightBehavior(
//                     applyHeightToFirstAscent: false,
//                     applyHeightToLastDescent: false,
//                   )),
//             ),
//           ),
//         )))
//     .toList();

// Widget buildDataTable(
//     BuildContext context, List<Map<String, dynamic>> selectedData) {
//   ScrollController scrollController = ScrollController();
//   List<String> columns = ["Topic", "Date", "Marks"];
//   List<List<String>> tableData = [];
//   selectedData.forEach(((element) {
//     if (element['marked']) {
//       tableData.add([
//         element['topic'],
//         element['date'],
//         "${element['mark']} / ${element['fm']}"
//       ]);
//     }
//   }));

//   List<DataRow> dataRowList = [];
//   for (var element in tableData) {
//     dataRowList.add(DataRow(cells: getRowCells(context, element)));
//   }

//   return Container(
//     // margin: EdgeInsets.symmetric(vertical: 10, horizontal: 0),
//     child: Column(
//       mainAxisAlignment: MainAxisAlignment.start,
//       crossAxisAlignment: CrossAxisAlignment.start,
//       children: [
//         // SizedBox(
//         //   height: 20,
//         //   child: Center(
//         //     child: Text(
//         //       "Time Table",
//         //       style: Theme.of(context).textTheme.titleLarge!.copyWith(
//         //           color: Theme.of(context).appBarTheme.foregroundColor,
//         //           fontWeight: FontWeight.bold),
//         //     ),
//         //   ),
//         // ),
//         // SizedBox(height: 10),
//         // Divider(
//         //   color: Theme.of(context).primaryColor.withOpacity(0.5),
//         //   thickness: 0,
//         //   indent: 40,
//         //   endIndent: 40,
//         // ),
//         Scrollbar(
//           controller: scrollController,
//           thumbVisibility: false,
//           interactive: false,
//           thickness: 2,
//           // showTrackOnHover: true,
//           // radius: Radius.circular(2),
//           child: SingleChildScrollView(
//             controller: scrollController,
//             scrollDirection: Axis.horizontal,
//             child: Padding(
//               padding: const EdgeInsets.only(bottom: 8.0),
//               child: DataTable(
//                 horizontalMargin: 0,
//                 // columnSpacing: MediaQuery.of(context).size.width / (5.0 * 3),
//                 columnSpacing: 5,
//                 headingTextStyle: TextStyle(
//                     // leadingDistribution: TextLeadingDistribution.even,
//                     ),
//                 // border: TableBorder.all(
//                 //   color: Theme.of(context).primaryColor.withOpacity(0.5),
//                 //   width: 1,
//                 //   style: BorderStyle.solid,
//                 // ),
//                 columns: getColumns(context, columns),
//                 rows: dataRowList,
//               ),
//             ),
//           ),
//         ),
//       ],
//     ),
//   );
// }
