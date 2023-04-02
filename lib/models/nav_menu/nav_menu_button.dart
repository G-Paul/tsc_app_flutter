import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import './hero_dialog_route.dart';
import './nav_menu.dart';
import './custom_rect_tween.dart';

class NavMenuButton extends StatelessWidget {
  const NavMenuButton({super.key});
  final String _heroNavMenu = "hero-nav-menu";
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 20),
      child: GestureDetector(
        onTap: (() {
          Navigator.of(context).push(HeroDialogRoute(builder: (context) {
            return NavMenu();
          }));
        }),
        child: Hero(
          tag: _heroNavMenu,
          createRectTween: (begin, end) {
            return CustomRectTween(begin: begin!, end: end!);
          },
          child: Material(
            color: Theme.of(context).appBarTheme.backgroundColor,
            // elevation: 2,
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
            child: Center(
              child: FaIcon(
                FontAwesomeIcons.userGraduate,
                color: Theme.of(context).focusColor,
                size: 20,
              ),
            ),
          ),
        ),
      ),
    );
  }
}