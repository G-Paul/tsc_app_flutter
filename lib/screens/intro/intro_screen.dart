import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:google_nav_bar/google_nav_bar.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:tsc_app/screens/intro/introPage1.dart';
import 'package:tsc_app/screens/intro/login_page.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

import '../admin/home/admin_home.dart';
import '../admin/students/admin_students.dart';
import '../admin/teachers/admin_teachers.dart';
import '../website/website_screen.dart';
// import 'login/login_button.dart';
import '../login/hero_digital_route.dart';
import '../login/login_card.dart';
import '../login/signed_in_card.dart';
import '../navigation_drawer.dart';
import './login_page.dart';
import './introPage1.dart';
import './introPage2.dart';
import './introPage3.dart';
import './introPage4.dart';

class IntroScreen extends StatefulWidget {
  const IntroScreen({super.key});

  @override
  State<IntroScreen> createState() => _IntroScreenState();
}

class _IntroScreenState extends State<IntroScreen> {
  int pageIndex = 0;
  final pageController = PageController(initialPage: 0);

  // @override
  // void initState() {
  //
  // }
  void _moveToLastPage() {
    setState(() {
      pageIndex = 4;
      pageController.jumpToPage(pageIndex);
    });
  }

  @override
  void dispose() {
    pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        color: Colors.blueAccent,
        child: PageView(
          controller: pageController,
          onPageChanged: (value) {
            setState(() {
              pageIndex = value;
            });
          },
          children: [
            IntroPage1(),
            IntroPage2(),
            IntroPage3(),
            IntroPage4(_moveToLastPage),
            LoginPage(),
          ],
        ),
      ),
      bottomNavigationBar: BottomAppBar(
        elevation: 0,
        color: Theme.of(context).backgroundColor,
        child: Container(
          // height: 40,
          color: Theme.of(context).backgroundColor,
          padding: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            mainAxisSize: MainAxisSize.max,
            children: [
              TextButton(
                style: TextButton.styleFrom(
                  primary: Theme.of(context).primaryColor,
                  surfaceTintColor: Theme.of(context).primaryColor,
                ),
                onPressed: (pageIndex == 0)
                    ? null
                    : () {
                        pageController.animateToPage(pageIndex - 1,
                            duration: Duration(milliseconds: 200),
                            curve: Curves.easeIn);
                      },
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      Icons.arrow_back_ios_outlined,
                      size: 15,
                      color: (pageIndex == 0)
                          ? Color.fromARGB(130, 158, 158, 158)
                          : Theme.of(context).primaryColor,
                    ),
                    SizedBox(
                      width: 5,
                    ),
                    Text(
                      "Back",
                      style: Theme.of(context).textTheme.titleSmall?.copyWith(
                          color: (pageIndex == 0)
                              ? Color.fromARGB(130, 158, 158, 158)
                              : Theme.of(context).primaryColor,
                          fontSize: 15),
                    )
                  ],
                ),
              ),
              Container(
                child: SmoothPageIndicator(
                  controller: pageController,
                  count: 5,
                  effect: ScrollingDotsEffect(
                    fixedCenter: true,
                    activeDotScale: 1.5,
                    activeDotColor:
                        Theme.of(context).primaryColor.withOpacity(0.7),
                    dotColor: Color.fromARGB(179, 205, 205, 196),
                    dotHeight: 8,
                    dotWidth: 8,
                    spacing: 5,
                  ),
                ),
              ),
              TextButton(
                style: TextButton.styleFrom(
                  primary: Theme.of(context).primaryColor,
                  surfaceTintColor: Theme.of(context).primaryColor,
                ),
                onPressed: (pageIndex > 3)
                    ? null
                    : () {
                        pageController.animateToPage(pageIndex + 1,
                            duration: Duration(milliseconds: 200),
                            curve: Curves.easeIn);
                      },
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      "Next",
                      style: Theme.of(context).textTheme.titleSmall?.copyWith(
                          color: (pageIndex > 3)
                              ? Color.fromARGB(130, 158, 158, 158)
                              : Theme.of(context).primaryColor,
                          fontSize: 15),
                    ),
                    SizedBox(
                      width: 5,
                    ),
                    Icon(
                      Icons.arrow_forward_ios_rounded,
                      size: 15,
                      color: (pageIndex > 3)
                          ? Color.fromARGB(130, 158, 158, 158)
                          : Theme.of(context).primaryColor,
                    ),
                  ],
                ),
              )
            ],
          ),
        ),
      ),
      floatingActionButton: (pageIndex < 3)
          ? TextButton(
              style: TextButton.styleFrom(
                primary: Theme.of(context).primaryColor,
                surfaceTintColor: Theme.of(context).primaryColor,
              ),
              onPressed: (() => pageController.animateToPage(4,
                  duration: Duration(milliseconds: 200),
                  curve: Curves.easeInOut)),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    "Skip to Login",
                    style: Theme.of(context).textTheme.titleSmall?.copyWith(
                        color: Theme.of(context).primaryColor, fontSize: 15),
                  ),
                  SizedBox(
                    width: 5,
                  ),
                  Icon(
                    Icons.keyboard_double_arrow_right_rounded,
                    size: 20,
                    color: Theme.of(context).primaryColor,
                  ),
                ],
              ),
            )
          : SizedBox(),
      floatingActionButtonLocation: FloatingActionButtonLocation.endTop,
    );
  }
}

// class LoginButton extends StatelessWidget {
//   const LoginButton({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       // color: Theme.of(context).appBarTheme.backgroundColor,
//       padding: EdgeInsets.symmetric(horizontal: 10),
//       child: GestureDetector(
//         onTap: () {
//           Navigator.of(context).push(HeroDialogRoute(builder: (context) {
//             return StreamBuilder<User?>(
//               stream: FirebaseAuth.instance.authStateChanges(),
//               builder: ((context, snapshot) {
//                 if (snapshot.hasData)
//                   return SignedInCard();
//                 else
//                   return LoginCard();
//               }),
//             );
//           }));
//         },
//         child: Hero(
//           tag: login_user,
//           // createRectTween: (begin, end) {
//           //   return CustomRectTween(begin: begin, end: end);
//           // },
//           child: Material(
//               color: Theme.of(context).appBarTheme.backgroundColor,
//               child: Icon(
//                 Icons.account_circle_outlined,
//               )),
//         ),
//       ),
//     );
//   }
// }
