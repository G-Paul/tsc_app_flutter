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
  List<Map<String, dynamic>> _notes = [];

  void getNotes() async {
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
    }
    print("sodfjlasdjflsdjlfjdsofjlkdsjfowejroijewoirjokwjfoijewf");
    print("${userClass}_${userCourse} ");
    print(notes);
    setState(() {
      _notes = notes;
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getNotes();
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      //select screen
      child: Column(
        children: [
          Expanded(
            child: ListView.builder(
              itemCount: _notes.length,
              itemBuilder: (context, index) {
                // return CustomListTile(
                //   // title: Text("${_notes[index]['topic']}"),
                //   // subtitle: Text("${_notes[index]['subject']}"),
                //   leadingIcon: Icons.picture_as_pdf,
                //   title: _notes[index]['topic'],
                //   context: context,
                //   trailing: Icon(Icons.download),
                //   onTap: null,
                //   onTapTrailing: () {},
                // );
                bool showDivider = true;
                // if (index == _notes.length - 1) showDivider = false;
                String fileName = _notes[index]['path'].split('/').last;
                return CustomDownloadTile(
                  title: _notes[index]['topic'],
                  subtitle: fileName,
                  url: _notes[index]['url'],
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
