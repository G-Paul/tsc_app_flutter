import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:google_fonts/google_fonts.dart';
import './login_card.dart';

class SignedInCard extends StatelessWidget {
  SignedInCard({super.key});

  final user = FirebaseAuth.instance.currentUser!;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32.0),
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
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Container(
                            child: Image.asset(
                              'assets/images/talent_sprint_class_logo_transparent.png',
                              fit: BoxFit.contain,
                            ),
                            height: 90,
                          ),
                          SizedBox(height: 20),
                          Text(
                            'Hello\n',
                            style: Theme.of(context).textTheme.bodySmall,
                          ),
                          Text(
                            '${user.displayName}',
                            style: Theme.of(context).textTheme.bodySmall,
                          ),
                          Text(
                            '${user.email}',
                            style: Theme.of(context).textTheme.bodySmall,
                          ),
                          SizedBox(
                            height: 20,
                          ),
                          ElevatedButton(
                            onPressed: () {
                              FirebaseAuth.instance.signOut();
                            },
                            child: Container(
                              padding: EdgeInsets.symmetric(vertical: 10),
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Icon(
                                    Icons.logout_outlined,
                                    size:
                                        MediaQuery.of(context).textScaleFactor *
                                            18,
                                  ),
                                  SizedBox(
                                    width: 5,
                                  ),
                                  Text('Sign Out'),
                                ],
                              ),
                            ),
                            style: ElevatedButton.styleFrom(
                                backgroundColor: Theme.of(context).buttonColor,
                                foregroundColor: Theme.of(context).focusColor,
                                textStyle: GoogleFonts.raleway(),
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(20 *
                                        MediaQuery.of(context)
                                            .textScaleFactor))),
                          ),
                        ],
                      )),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
