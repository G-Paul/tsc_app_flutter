import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:google_nav_bar/google_nav_bar.dart';
import 'package:firebase_auth/firebase_auth.dart';

import './admin/home/admin_home.dart';
import './admin/students/admin_students.dart';
import './admin/teachers/admin_teachers.dart';
import './website/website_screen.dart';
// import 'login/login_button.dart';
import 'login/hero_digital_route.dart';
import './login/login_card.dart';
import './login/signed_in_card.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  final List<Map<String, Object>> _pages = [
    {'page': AdminHomeScreen(), 'title': 'Admin Home'},
    {'page': AdminStudentsScreen(), 'title': 'Admin Students'},
    {'page': AdminTeachersScreen(), 'title': 'Admin Teachers Home'},
    {'page': WebsiteScreen(), 'title': 'Website'},
  ];

  int _selectedPage = 0;

  void _selectPage(int index) {
    setState(() {
      _selectedPage = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).appBarTheme.backgroundColor,
        leading: IconButton(
          color: Theme.of(context).appBarTheme.foregroundColor,
          icon: const Icon(
            Icons.menu_outlined,
            semanticLabel: "Menu Button",
          ),
          onPressed: () {},
        ),
        title: Center(
          child: Text(
            "Talent Sprint Classes",
            style: Theme.of(context)
                .textTheme
                .titleLarge!
                .copyWith(color: Theme.of(context).appBarTheme.foregroundColor),
          ),
        ),
        actions: [
          // Material(
          //   child: Hero(
          //     tag: login_user,
          //     child: IconButton(
          //         icon: Icon(
          //           Icons.account_circle_outlined,
          //           color: Theme.of(context).appBarTheme.foregroundColor,
          //         ),
          //         onPressed: () {
          //           Navigator.of(context)
          //               .push(HeroDialogRoute(builder: (context) {
          //             return const LoginCard();
          //           }));
          //         }),
          //   ),
          // ),
          LoginButton(),
        ],
      ),
      bottomNavigationBar: Container(
        color: Theme.of(context).bottomAppBarColor,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 15),
          child: GNav(
            onTabChange: (value) => _selectPage(value),
            gap: 10,
            backgroundColor: Theme.of(context).bottomAppBarColor,
            color: Theme.of(context).iconTheme.color!.withOpacity(0.7),
            activeColor: Theme.of(context).iconTheme.color!,
            tabBackgroundColor: Theme.of(context).primaryColor.withOpacity(0.3),
            padding: EdgeInsets.all(10),
            tabs: [
              GButton(
                icon: Icons.home_outlined,
                text: "Home",
              ),
              GButton(
                icon: Icons.account_circle_outlined,
                text: "Student",
              ),
              GButton(
                icon: Icons.school_outlined,
                text: "Teacher",
              ),
              GButton(icon: Icons.language_outlined, text: "Website"),
            ],
          ),
        ),
      ),
      body: _pages[_selectedPage]['page'] as Widget?,
      backgroundColor: const Color(0xFFFDFDF5),
    );
  }
}

class LoginButton extends StatelessWidget {
  const LoginButton({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 10),
      child: GestureDetector(
        onTap: () {
          Navigator.of(context).push(HeroDialogRoute(builder: (context) {
            return StreamBuilder<User?>(
              stream: FirebaseAuth.instance.authStateChanges(),
              builder: ((context, snapshot) {
                if (snapshot.hasData)
                  return SignedInCard();
                else
                  return LoginCard();
              }),
            );
          }));
        },
        child: Hero(
          tag: login_user,
          // createRectTween: (begin, end) {
          //   return CustomRectTween(begin: begin, end: end);
          // },
          child: Material(
              child: Icon(
            Icons.account_circle_outlined,
          )),
        ),
      ),
    );
  }
}
