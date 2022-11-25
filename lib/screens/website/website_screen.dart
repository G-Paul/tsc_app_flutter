import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class WebsiteScreen extends StatelessWidget {
  WebsiteScreen({super.key});
  final Uri url = Uri.parse("https://project-tsc.netlify.app");

  Future<void> launch_Url() async {
    if (!await launchUrl(url)) {
      throw 'Could not launch $url';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: GestureDetector(
        onTap: launch_Url,
        child: Image.asset(
          "assets/images/talent_sprint_class_logo_transparent.png",
          width: 300,
          height: 300,
        ),
      ),
    );
  }
}
