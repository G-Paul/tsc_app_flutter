import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/material.dart';
import '/models/db/database.dart';

class NavDrawer extends StatelessWidget {
  const NavDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: SingleChildScrollView(
        child: Column(
          children: [
            Padding(
              padding:
                  EdgeInsets.only(top: MediaQuery.of(context).viewPadding.top),
            ),
            TextButton(
              onPressed: (() {}),
              child: Text("Dark Mode"),
            ),
            OutlinedButton(
                onPressed: () {
                  UserAuth().logout();
                  Navigator.pushReplacementNamed(context, '/IntroScreen');
                },
                child: Text("Sign Out")),
          ],
        ),
      ),
    );
  }
}
