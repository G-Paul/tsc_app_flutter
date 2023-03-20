import 'package:flutter/material.dart';
import '../db/database.dart';
import './custom_rect_tween.dart';

class NavMenu extends StatelessWidget {
  const NavMenu({super.key});
  final String _heroNavMenu = "hero-nav-menu";

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: EdgeInsets.all(10),
        child: Hero(
          tag: _heroNavMenu,
          createRectTween: (begin, end) {
            return CustomRectTween(begin: begin!, end: end!);
          },
          child: Material(
            color: Theme.of(context).backgroundColor,
            // elevation: 2,
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
            child: Container(
              padding: EdgeInsets.all(20),
              height: MediaQuery.of(context).size.height * 0.65,
              width: MediaQuery.of(context).size.width * 0.8,
              child: SingleChildScrollView(
                // scrollDirection: ,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text("Talent Sprint Classes",
                        style: Theme.of(context).textTheme.titleLarge),
                    SizedBox(height: 20),
                    ElevatedButton(
                        onPressed: () {
                          UserAuth().logout();
                          Navigator.pushReplacementNamed(
                              context, '/IntroScreen');
                        },
                        child: Text("SignOut")),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
