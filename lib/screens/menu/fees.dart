import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:flutter/services.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../../models/db/database.dart';

class FeesScreen extends StatefulWidget {
  const FeesScreen({super.key});

  @override
  State<FeesScreen> createState() => _FeesScreenState();
}

class _FeesScreenState extends State<FeesScreen> {
  bool _isLoading = false;
  late String _userCourse;
  late int _userClass;
  bool _isPaid = false;
  String? _txId;
  DateTime? _txDate;

  void getUserDetails() async {
    setState(() {
      _isLoading = true;
    });
    //MILESTONE 1: Get student details from the student doc (class, course, subjects)
    await db.collection('students').doc(user.uid).get().then((value) {
      setState(() {
        _userCourse = value.data()!['course'];
        _userClass = value.data()!['class'];
        _isPaid = value.data()!['paid'];
        // _txId = value.data()!['txid'];
        // _txDate = DateTime.tryParse(value.data()!['txdate']);
      });
    });
    setState(() {
      _isLoading = false;
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getUserDetails();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Fees"),
      ),
      body: (_isLoading)
          ? Center(
              child: CircularProgressIndicator(
                  color: Theme.of(context).primaryColor),
            )
          : SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  studentDetails(
                    context: context,
                    userName: user.displayName!,
                    userClass: _userClass,
                    userCourse: _userCourse,
                    isPaid: _isPaid,
                  ),
                  // (_txId != null && _txDate != null)
                  //     ? lastPaid(context: context, date: _txDate!, txId: _txId!)
                  //     : SizedBox(),
                  Container(
                    padding: EdgeInsets.all(20),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SizedBox(
                          child: Text(
                            "Fee Payment Process:",
                            style: Theme.of(context).textTheme.bodyLarge,
                          ),
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        SizedBox(
                          child: Text(
                            "1. Pay the fee at the following UPI ID from any UPI app.",
                            style: Theme.of(context).textTheme.bodySmall,
                          ),
                        ),
                        Container(
                          height: 60,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(20),
                            border: Border.all(
                                color: Theme.of(context).primaryColor,
                                width: 2,
                                strokeAlign: BorderSide.strokeAlignOutside),
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              ConstrainedBox(
                                constraints: BoxConstraints(
                                    maxWidth:
                                        MediaQuery.of(context).size.width - 80),
                                child: Text(
                                  "iuowieruoweirjoweijflkjsdflkasj",
                                  maxLines: 1,
                                  softWrap: false,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                              Container(
                                decoration: BoxDecoration(
                                  color: Theme.of(context).primaryColor,
                                  borderRadius: BorderRadius.only(
                                    topRight: Radius.circular(20),
                                    bottomRight: Radius.circular(20),
                                  ),
                                ),
                                width: 60,
                                height: 60,
                                child: InkWell(
                                  splashColor: Theme.of(context).focusColor,
                                  overlayColor: MaterialStateProperty.all(
                                      Theme.of(context).primaryColor),
                                  onTap: () {},
                                  child: Center(
                                    child: FaIcon(
                                      FontAwesomeIcons.copy,
                                      color: Colors.white,
                                      size: 20,
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        SizedBox(
                          child: Text(
                            "2. Upload a screenshot of the payment. Make sure that the entire transaction ID is visible.",
                            style: Theme.of(context).textTheme.bodySmall,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
    );
  }
}

Widget studentDetails(
    {required BuildContext context,
    required String userName,
    required String userCourse,
    required int userClass,
    required bool isPaid}) {
  final box_width = MediaQuery.of(context).size.width * 0.9;
  final avatar_radius = box_width / 9;
  final padding = 20.0;
  final double borderRadius = 15;

  final double borderWidth = 2;
  // final userclass = 10;
  // final usercourse = "ICSE";
  return Container(
    padding: EdgeInsets.all(padding),
    margin: EdgeInsets.all(10),
    decoration: BoxDecoration(
      borderRadius: BorderRadius.circular(borderRadius),
      color: Theme.of(context).backgroundColor,
      border: Border.all(
        color: (isPaid)
            ? Theme.of(context).primaryColor
            : Theme.of(context).focusColor,
        width: borderWidth,
      ),
    ),
    child: Row(
      children: [
        CircleAvatar(
          backgroundColor: Theme.of(context).focusColor,
          radius: avatar_radius,
          child: CircleAvatar(
            backgroundImage: AssetImage('assets/images/cristina_avatar.png'),
            radius: avatar_radius - 4,
          ),
        ),
        SizedBox(
          width: padding,
        ),
        Container(
          // height: avatar_radius * 2,
          // decoration: BoxDecoration(color: Colors.blue),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                // decoration: BoxDecoration(color: Colors.orange),
                width: box_width - avatar_radius * 2 - padding * 3,
                child: Text(
                  userName,
                  style: Theme.of(context).textTheme.titleLarge,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              Container(
                // decoration: BoxDecoration(color: Colors.blue),
                width: box_width - avatar_radius * 2 - padding * 3,
                child: Text("Class $userClass \u30fb $userCourse",
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: Theme.of(context).textTheme.titleSmall!.copyWith(
                          color: Theme.of(context)
                              .textTheme
                              .titleLarge!
                              .color!
                              .withOpacity(0.5),
                        )),
              ),
              Container(
                // decoration: BoxDecoration(color: Colors.blue),
                width: box_width - avatar_radius * 2 - padding * 3,
                child: Text("Fee Status: ${(isPaid) ? "Paid" : "Not Paid"}",
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: Theme.of(context).textTheme.titleSmall!.copyWith(
                          color: (isPaid)
                              ? Theme.of(context).primaryColor
                              : Theme.of(context).focusColor,
                        )),
              ),
            ],
          ),
        ),
      ],
    ),
  );
}

Widget lastPaid({
  required BuildContext context,
  required String txId,
  required DateTime date,
}) {
  final padding = 20.0;
  final double borderRadius = 15;

  final double borderWidth = 2;
  return Container(
    padding: EdgeInsets.all(padding),
    margin: EdgeInsets.all(10),
    decoration: BoxDecoration(
      borderRadius: BorderRadius.circular(borderRadius),
      color: Theme.of(context).backgroundColor,
      // border: Border.all(
      //   color: Theme.of(context).primaryColor,
      //   width: borderWidth,
      // ),
    ),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "Last Transaction: ",
          style: Theme.of(context).textTheme.titleSmall,
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            ConstrainedBox(
              constraints: BoxConstraints(
                  maxWidth:
                      MediaQuery.of(context).size.width - padding * 4 - 40),
              child: Text(
                "ID: $txId",
                overflow: TextOverflow.fade,
                softWrap: false,
                maxLines: 1,
              ),
            ),
            IconButton(
              onPressed: () async {
                Clipboard.setData(ClipboardData(text: txId)).then((_) {
                  ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                      content: Text("Transaction ID copied to clipboard")));
                });
              },
              icon: FaIcon(
                FontAwesomeIcons.copy,
                color: Theme.of(context).focusColor,
                size: 20,
              ),
            )
          ],
        ),
        Text("Date: ${DateFormat.yMd().format(date)}")
      ],
    ),
  );
}

/*
TO-DO: 
1. Fetch user details (name, class, section, fee payment)
*/