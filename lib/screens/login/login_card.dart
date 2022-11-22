import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';

const String login_user = 'login_user';

class LoginCard extends StatefulWidget {
  const LoginCard({super.key});

  @override
  State<LoginCard> createState() => _LoginCardState();
}

class _LoginCardState extends State<LoginCard> {
  final emailController = TextEditingController();
  final pwController = TextEditingController();

  Future signIn() async {
    await FirebaseAuth.instance.signInWithEmailAndPassword(
      email: emailController.text.trim(),
      password: pwController.text.trim(),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Hero(
        tag: login_user,
        // createRectTween: (begin, end) {
        //   return CustomRectTween(begin: begin, end: end);
        // },
        child: Material(
          color: Theme.of(context).backgroundColor,
          elevation: 2,
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(32)),
          child: SizedBox(
            height: MediaQuery.of(context).size.height / 2,
            width: MediaQuery.of(context).size.width * 0.8,
            child: Center(
              child: SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Column(
                    mainAxisSize: MainAxisSize.max,
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Container(
                        child: Image.asset(
                          'assets/images/talent_sprint_class_logo_transparent.png',
                          fit: BoxFit.contain,
                        ),
                        height: 90,
                      ),
                      SizedBox(height: 20),
                      TextField(
                        controller: emailController,
                        decoration: InputDecoration(
                          hintText: 'Email',
                          border: InputBorder.none,
                        ),
                        // cursorColor: Colors.white,
                      ),
                      Divider(
                        color: Theme.of(context).primaryColor.withOpacity(0.5),
                        thickness: 0.2,
                      ),
                      TextField(
                        controller: pwController,
                        obscureText: true,
                        decoration: InputDecoration(
                          hintText: 'Password',
                          border: InputBorder.none,
                        ),
                      ),
                      Divider(
                        color: Theme.of(context).primaryColor.withOpacity(0.5),
                        thickness: 0.2,
                      ),
                      SizedBox(height: 20),
                      ElevatedButton(
                        onPressed: () => signIn(),
                        child: Container(
                          // height: 40,
                          padding: EdgeInsets.symmetric(vertical: 10),
                          child: FittedBox(
                            fit: BoxFit.contain,
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Icon(
                                  Icons.exit_to_app,
                                  size: MediaQuery.of(context).textScaleFactor *
                                      18,
                                ),
                                SizedBox(
                                  width: 5,
                                ),
                                const Text('Sign In'),
                              ],
                            ),
                          ),
                        ),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Theme.of(context).buttonColor,
                          foregroundColor: Theme.of(context)
                              .iconTheme
                              .color!
                              .withOpacity(0.7),
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(
                                  20 * MediaQuery.of(context).textScaleFactor)),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
