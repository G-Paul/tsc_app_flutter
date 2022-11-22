import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import './login_card.dart';
import './hero_digital_route.dart';

class LoginButton extends StatelessWidget {
  const LoginButton({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 10),
      child: GestureDetector(
        onTap: () {
          Navigator.of(context).push(HeroDialogRoute(builder: (context) {
            return const LoginCard();
          }));
        },
        child: Container(
          height: Theme.of(context).appBarTheme.toolbarHeight,
          width: Theme.of(context).appBarTheme.toolbarHeight,
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
      ),
    );
  }
}
