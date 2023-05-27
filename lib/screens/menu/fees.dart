import 'dart:io';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:flutter/services.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../../models/db/database.dart';
import '../../models/widgets/customAlertDialog.dart';


class FeesScreen extends StatefulWidget {
  const FeesScreen({super.key});

  @override
  State<FeesScreen> createState() => _FeesScreenState();
}

class _FeesScreenState extends State<FeesScreen> {
  bool _isLoading = false;
  Map<String, dynamic> _student = {};
  late String _userCourse;
  late int _userClass;
  bool _isPaid = false;
  String buttonText = "Upload";
  bool _uploading = false;
  String? _txId;
  DateTime? _txDate;
  final String upiID = "gunjanpaul05@okaxis";
  File? _image;
  final _picker = ImagePicker();

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
        setState(() {
          _student = value.data()!;
        });
        // _txId = value.data()!['txid'];
        // _txDate = DateTime.tryParse(value.data()!['txdate']);
      });
    });
    setState(() {
      _isLoading = false;
    });
  }

  Future pickImage() async {
    final pickedImage = await _picker.pickImage(source: ImageSource.gallery);

    setState(() {
      if (pickedImage != null) {
        _image = File(pickedImage.path);
      } else {
        print('No image selected.');
      }
    });
  }

  Future uploadImageToFirebase() async {
    if (_image != null) {
      setState(() {
        _uploading = true;
        buttonText = "Uploading...";
      });
      // String filePath = `fees/${student.value.course}_${student.value.class}/${student.value.name}_${file.name}`;
      // String filePath = '';
      String filePath = 'fees/${_userCourse}_${_userClass}/${user.displayName}_fees_${DateFormat('dd-MM-yyyy').format(DateTime.now())}.${_image!.path.split('.').last}';
      FirebaseStorage storage = FirebaseStorage.instance;
      Reference reference =
          storage.ref().child(filePath);

      UploadTask uploadTask = reference.putFile(_image!);
      TaskSnapshot taskSnapshot = await uploadTask.whenComplete(() => null);

      String downloadURL = await taskSnapshot.ref.getDownloadURL();
      if(downloadURL.isNotEmpty) {
        _student['paid'] = true;
        _student['ssURL'] = downloadURL;
        _student['ssPath'] = filePath;
        db.collection('students').doc(user.uid).update(_student).then((value) => {
          setState(() {
            _isPaid = true;
            _uploading = false;
            buttonText = "Uploaded";
          }),
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            content: Text("Fees uploaded successfully"),
            duration: Duration(seconds: 1),
          ))
        });
      }
      // print('Image uploaded: $downloadURL');
    }
    else {
      print("NO file found");
    }
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
                            style: Theme.of(context).textTheme.bodyMedium!.copyWith(color: Theme.of(context).primaryColor, fontSize: 18, fontWeight: FontWeight.bold),
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
                          margin: EdgeInsets.symmetric(vertical: 15),
                          decoration: BoxDecoration(
                            color: Theme.of(context).backgroundColor,
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
                                child: InkWell(
                                  onTap: () {
                                    //copy upiID to clipboard
                                    Clipboard.setData(
                                        ClipboardData(text: upiID));
                                    //display a popup that the upiID has been copied
                                    ScaffoldMessenger.of(context)
                                        .showSnackBar(SnackBar(
                                      content: Text("UPI ID copied"),
                                      duration: Duration(seconds: 1),
                                    ));
                                  },
                                  child: Container(
                                    margin: EdgeInsets.only(left: 20),
                                    child: Text(
                                      upiID,
                                      maxLines: 1,
                                      softWrap: false,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  ),
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
                                  onTap: () {
                                    //copy upiID to clipboard
                                    Clipboard.setData(
                                        ClipboardData(text: upiID));
                                    //display a popup that the upiID has been copied
                                    ScaffoldMessenger.of(context)
                                        .showSnackBar(SnackBar(
                                      content: Text("UPI ID copied"),
                                      duration: Duration(seconds: 1),
                                    ));
                                  },
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
                            "2. Select the screenshot of the payment. Make sure that the entire transaction ID is visible.",
                            style: Theme.of(context).textTheme.bodySmall,
                          ),
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        //Make a button to upload a picture of the payment
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            InkWell(
                              onTap: pickImage,
                              child: Container(
                                height: MediaQuery.of(context).size.width/2,
                                width: MediaQuery.of(context).size.width/2, 
                                decoration: BoxDecoration(
                                  //translucent background
                                  color: Theme.of(context)
                                      .primaryColor
                                      .withOpacity(0.2),
                                  border: Border.all(
                                    color: Theme.of(context).primaryColor,
                                    width: 2,
                                    style: BorderStyle.solid,
                                  ),
                                  borderRadius: BorderRadius.circular(20),
                                ),
                                child: _image == null
                                    ? Center(
                                        child: Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: [
                                            FaIcon(
                                              FontAwesomeIcons.upload,
                                              color: Theme.of(context)
                                                  .focusColor,
                                              size: 30,
                                            ),
                                            SizedBox(
                                              height: 10,
                                            ),
                                            Padding(
                                              padding: const EdgeInsets.all(15),
                                              child: Text(
                                                "Upload Payment Screenshot",
                                                textAlign: TextAlign.center,
                                                style: Theme.of(context)
                                                    .textTheme
                                                    .bodyMedium,
                                              ),
                                            ),
                                          ],
                                        ),
                                      )
                                    : Image.file(
                                        _image!,
                                        fit: BoxFit.contain,
                                      ),
                              ),
                            ),
                            
                            // OutlinedButton(
                            //   // Same theme as all other buttons
                            //   style: ElevatedButton.styleFrom(
                            //     primary: Theme.of(context).primaryColor,
                            //     shape: RoundedRectangleBorder(
                            //       borderRadius: BorderRadius.circular(20),
                            //     ),
                            //   ),
                            //   onPressed: () {
                            //     //handle the upload of the image here

                            //   },
                            //   child: Padding(
                            //     padding: const EdgeInsets.all(8.0),
                            //     child: Text("Upload Payment Screenshot",
                            //     //same text style as other fonts in the app, have the text color as white
                            //     style: Theme.of(context).textTheme.bodyMedium!.copyWith(color: Colors.white),
                                
                            //     ),
                            //   ),
                            // ),
                          ],
                          
                        ),
                        SizedBox(
                          height: 20,
                        ),
                        SizedBox(
                          child: Text(
                            "3. Upload the screenshot of the payment",
                            style: Theme.of(context).textTheme.bodySmall,
                          ),
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            OutlinedButton(
                                  // Same theme as all other buttons
                                  style: OutlinedButton.styleFrom(
                                    // foregroundColor: Theme.of(context).primaryColor,
                                    backgroundColor: (buttonText == "Uploading..."|| buttonText == "Uploaded")?Theme.of(context).disabledColor.withOpacity(0.2):(_image == null || _isPaid)?Theme.of(context).focusColor.withOpacity(0.2):Theme.of(context).primaryColor.withOpacity(0.2),
                                    //make the border color primary
                                    side: BorderSide(
                                      color: (buttonText == "Uploading..."|| buttonText == "Uploaded")?Theme.of(context).disabledColor:(_image == null || _isPaid)?Theme.of(context).focusColor:Theme.of(context).primaryColor,
                                      width: 2,
                                    ),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(20),
                                      ),
                                  ),
                                  onPressed: () {
                                    //if image is null then show a snackbar warning the user to upload an image
                                    if(_image == null){
                                      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                                        content: Text("Please upload a screenshot of the payment"),
                                        duration: Duration(seconds: 1),
                                      ));
                                    }
                                    else if(_isPaid){
                                      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                                        content: Text("Fees already paid. No need to re-upload."),
                                        duration: Duration(seconds: 1),
                                      ));
                                    }
                                    else{
                                      uploadImageToFirebase();
                                    }
                                  },
                                  child: Padding(
                                    padding: const EdgeInsets.all(15),
                                    child: Text(buttonText,
                                    //same text style as other fonts in the app, have the text color as white
                                    style: Theme.of(context).textTheme.bodyMedium!.copyWith(),
                                    
                                    ),
                                  ),
                                ),
                          ],
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