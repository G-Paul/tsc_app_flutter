import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '/models/db/database.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final emailController = TextEditingController();
  final pwController = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  late ValueNotifier<bool> _radioSelected;
  final userTypeList = ["student", "teacher", "admin"];
  int userType = -1; //0->student, 1->Teacher, 2->Admin
  bool firstTime = true;

  Future _signIn() async {
    showDialog(
        context: context,
        builder: ((context) {
          return Center(
            child: CircularProgressIndicator(
              color: Theme.of(context).primaryColor,
              semanticsLabel: "Logging in...",
            ),
          );
        }));
    SharedPreferences prefs = await SharedPreferences.getInstance();
    try {
      // await FirebaseAuth.instance
      //     .signInWithEmailAndPassword(
      //       email: emailController.text.trim(),
      //       password: pwController.text.trim(),
      //     )
      //     .then((userCreds) async {});
      final user = await UserAuth()
          .login(emailController.text.trim(), pwController.text.trim());
      if (user != null) {
        final docRef =
            db.collection('${userTypeList[userType]}s').doc(user.uid);
        await docRef.get().then((doc) {
          if (doc.exists) {
            // Navigator.of(context).pop();
            prefs.setString('userType', userTypeList[userType]);
            prefs.setBool('isLoggedIn', true);
            switch (userTypeList[userType]) {
              case 'student':
                Navigator.of(context).pushNamedAndRemoveUntil(
                    '/StudentMainScreen', ((route) => false));
                break;
              default:
                Navigator.of(context).pushReplacementNamed('/MainScreen');
            }
          } else {
            UserAuth().logout();
            prefs.setBool('isLoggedIn', false);
            Navigator.of(context).pop();
            ScaffoldMessenger.of(context).showSnackBar(SnackBar(
              content: Text('Please select correct user type!'),
              backgroundColor: Colors.red,
            ));
          }
        });
      }
    } on FirebaseAuthException catch (e) {
      String message = "";
      switch (e.code) {
        case "user-not-found":
          message = "No user found for that email.";
          break;
        default:
          message = e.message!;
      }
      Navigator.of(context).pop();
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text(message, maxLines: 2),
        backgroundColor: Colors.red,
      ));
    }

    // Navigator.of(context).pop();
    // Navigator.of(context).pushReplacementNamed('/MainScreen');
  }

  Widget CustomRadioButton(String text, int index) {
    return OutlinedButton(
      onPressed: () {
        setState(() {
          userType = index;
        });
      },
      style: OutlinedButton.styleFrom(
          backgroundColor:
              (userType == index) ? Theme.of(context).primaryColor : null,
          shape: const StadiumBorder(),
          primary: Theme.of(context).primaryColor,
          side: BorderSide(
            width: 1,
            color: Theme.of(context).primaryColor,
          )),
      child: Text(
        text,
        style: Theme.of(context).textTheme.titleSmall?.copyWith(
              color: (index == userType)
                  ? Colors.white
                  : Theme.of(context).primaryColor,
              fontSize: 12,
            ),
      ),
    );
  }

  @override
  void initState() {
    super.initState();
    _radioSelected = ValueNotifier<bool>(true);
    _radioSelected.addListener(() {
      if (!firstTime && userType == -1)
        _radioSelected.value = false;
      else
        _radioSelected.value = true;
    });
  }

  @override
  void dispose() {
    emailController.dispose();
    pwController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.only(top: 00, bottom: 0, right: 20, left: 20),
      color: Theme.of(context).backgroundColor,
      child: SingleChildScrollView(
        child: Form(
          key: _formKey,
          child: Center(
            child: Padding(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  SizedBox(height: MediaQuery.of(context).size.height * 0.1),
                  Container(
                    padding: EdgeInsets.all(20),
                    height: MediaQuery.of(context).size.height * 0.25,
                    // width: MediaQuery.of(context).size.width * 0.55,
                    child: Image.asset(
                        'assets/images/talent_sprint_class_logo_transparent.png',
                        fit: BoxFit.contain),
                  ),
                  const SizedBox(
                    height: 30,
                  ),
                  TextFormField(
                    style: Theme.of(context).textTheme.bodySmall,
                    controller: emailController,
                    validator: (value) {
                      return validateEmail(value, firstTime);
                    },
                    onEditingComplete: () {
                      FocusScope.of(context).nextFocus();
                    },
                    onChanged: (_) {
                      _formKey.currentState!.validate();
                    },
                    decoration: InputDecoration(
                      labelText: 'Email',
                      labelStyle:
                          Theme.of(context).textTheme.labelSmall?.copyWith(
                                fontWeight: FontWeight.w600,
                                // color: Theme.of(context).primaryColor,
                              ),
                      // hintText: 'Email',
                      // hintStyle: Theme.of(context).textTheme.labelSmall,
                      border: InputBorder.none,
                    ),
                    cursorColor: Theme.of(context).primaryColor,
                  ),
                  Divider(
                    color: Theme.of(context).dividerColor,
                    thickness: 0.4,
                  ),
                  TextFormField(
                    style: Theme.of(context).textTheme.bodySmall,
                    controller: pwController,
                    validator: (value) {
                      return validatePassword(value, firstTime);
                    },
                    obscureText: true,
                    decoration: InputDecoration(
                      labelText: 'Password',
                      labelStyle:
                          Theme.of(context).textTheme.labelSmall?.copyWith(
                                fontWeight: FontWeight.w600,
                                // color: Theme.of(context).primaryColor,
                              ),
                      // hintText: 'Password',
                      // hintStyle: Theme.of(context).textTheme.labelSmall,
                      border: InputBorder.none,
                    ),
                    cursorColor: Theme.of(context).primaryColor,
                  ),
                  Divider(
                    color: Theme.of(context).dividerColor,
                    thickness: 0.4,
                  ),
                  SizedBox(height: 20),
                  ValueListenableBuilder(
                    valueListenable: _radioSelected,
                    builder: ((context, value, child) {
                      if (value) {
                        return SizedBox(
                          child: Text(
                            "Login as",
                            style: Theme.of(context)
                                .textTheme
                                .labelSmall
                                ?.copyWith(
                                  fontWeight: FontWeight.w600,
                                ),
                          ),
                        );
                      } else {
                        return SizedBox(
                          child: Text(
                            "Please select a User Type!",
                            style: Theme.of(context)
                                .textTheme
                                .labelSmall
                                ?.copyWith(
                                  fontWeight: FontWeight.w600,
                                  color: Theme.of(context).errorColor,
                                ),
                          ),
                        );
                      }
                    }),
                  ),
                  SizedBox(height: 10),
                  Container(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        CustomRadioButton("Student", 0),
                        CustomRadioButton("Teacher", 1),
                        CustomRadioButton("Admin", 2),
                      ],
                    ),
                  ),
                  SizedBox(height: 20),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      minimumSize: Size(200, 50),
                      shape: StadiumBorder(),
                      primary: Theme.of(context).indicatorColor,
                    ),
                    onPressed: (() {
                      firstTime = false;
                      if (userType == -1) {
                        // _radioSelected.value = false;
                        setState(() {
                          _radioSelected.value = false;
                        });
                        return;
                      }
                      if (_formKey.currentState!.validate()) {
                        _signIn();
                      }
                    }),
                    child: SizedBox(
                      width: MediaQuery.of(context).size.width * 0.4,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        mainAxisSize: MainAxisSize.max,
                        children: [
                          Text(
                            "Login",
                            style: Theme.of(context)
                                .textTheme
                                .titleSmall
                                ?.copyWith(
                                  color: Colors.white,
                                  fontSize: 20,
                                ),
                          ),
                          SizedBox(
                            width: 10,
                          ),
                          SizedBox(
                              child: const Icon(Icons.exit_to_app_rounded)),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

String? validateEmail(String? value, bool firstTime) {
  if (!firstTime && (value == null || value.isEmpty)) {
    return 'Email is required';
  }
  const String regex_pattern = r'\w+@\w+\.\w+';
  RegExp regex = RegExp(regex_pattern);
  if (!firstTime && !regex.hasMatch(value!)) {
    return 'Invalid Email';
  }
  return null;
}

String? validatePassword(String? value, bool firstTime) {
  if (!firstTime && (value == null || value.isEmpty)) {
    return 'Pass is required';
  }
  if (!firstTime && value!.length < 6) {
    return 'Password must be at least 6 characters';
  }
  return null;
}
