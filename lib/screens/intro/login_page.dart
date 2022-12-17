import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final emailController = TextEditingController();
  final pwController = TextEditingController();
  int userType = -1; //0->student, 1->Teacher, 2->Admin

  Future signIn() async {
    showDialog(
        context: context,
        builder: ((context) {
          return Center(
            child: CircularProgressIndicator(
              color: Theme.of(context).primaryColor,
              semanticsLabel: "Logging in",
            ),
          );
        }));
    await FirebaseAuth.instance.signInWithEmailAndPassword(
      email: emailController.text.trim(),
      password: pwController.text.trim(),
    );
    Navigator.of(context).pop();
  }

  Widget CustomRadioButton(String text, int index) {
    return OutlinedButton(
      onPressed: () {
        setState(() {
          userType = index;
        });
      },
      child: Text(
        text,
        style: Theme.of(context).textTheme.titleSmall?.copyWith(
              color: (index == userType)
                  ? Colors.white
                  : Theme.of(context).primaryColor,
              fontSize: 12,
            ),
      ),
      style: OutlinedButton.styleFrom(
          backgroundColor:
              (userType == index) ? Theme.of(context).primaryColor : null,
          shape: StadiumBorder(),
          primary: Theme.of(context).primaryColor,
          side: BorderSide(
            width: 1,
            color: Theme.of(context).primaryColor,
          )),
    );
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
                SizedBox(
                  height: 30,
                ),
                TextField(
                  style: Theme.of(context).textTheme.bodySmall,

                  controller: emailController,
                  decoration: InputDecoration(
                    hintText: 'Email',
                    hintStyle: Theme.of(context).textTheme.labelSmall,
                    border: InputBorder.none,
                  ),
                  // cursorColor: Colors.white,
                ),
                Divider(
                  color: Theme.of(context).dividerColor,
                  thickness: 0.4,
                ),
                TextField(
                  style: Theme.of(context).textTheme.bodySmall,
                  controller: pwController,
                  obscureText: true,
                  decoration: InputDecoration(
                    hintText: 'Password',
                    hintStyle: Theme.of(context).textTheme.labelSmall,
                    border: InputBorder.none,
                  ),
                ),
                Divider(
                  color: Theme.of(context).dividerColor,
                  thickness: 0.4,
                ),
                SizedBox(height: 20),
                SizedBox(
                  child: Text(
                    "Login As: ",
                    style: Theme.of(context).textTheme.labelSmall,
                  ),
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
                    primary: Theme.of(context).buttonColor,
                  ),
                  onPressed: (emailController.text != null &&
                          pwController.text != null &&
                          userType != -1)
                      ? (() => signIn())
                      : null,
                  child: SizedBox(
                    width: MediaQuery.of(context).size.width * 0.4,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      mainAxisSize: MainAxisSize.max,
                      children: [
                        Text(
                          "Login",
                          style:
                              Theme.of(context).textTheme.titleSmall?.copyWith(
                                    color: Colors.white,
                                    fontSize: 20,
                                  ),
                        ),
                        SizedBox(
                          width: 10,
                        ),
                        SizedBox(child: const Icon(Icons.exit_to_app_rounded)),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
