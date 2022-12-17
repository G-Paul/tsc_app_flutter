import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class IntroPage4 extends StatelessWidget {
  final Function moveToLastPage;
  IntroPage4(this.moveToLastPage, {super.key});
  final Uri url = Uri.parse("https://project-tsc.netlify.app");

  Future<void> launch_Url() async {
    if (!await launchUrl(url)) {
      throw 'Could not launch $url';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.only(top: 00, bottom: 20, right: 20, left: 20),
      color: Theme.of(context).backgroundColor,
      child: Center(
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              SizedBox(height: MediaQuery.of(context).size.height * 0.1),
              Container(
                height: MediaQuery.of(context).size.height * 0.25,
                // width: MediaQuery.of(context).size.width * 0.55,
                child: Image.asset('assets/images/intro-screen/intro-certi.png',
                    fit: BoxFit.contain),
              ),
              SizedBox(
                height: 30,
              ),
              Container(
                child: Text(
                  "Interested?",
                  style: Theme.of(context).textTheme.displayLarge,
                ),
              ),
              SizedBox(
                height: 20,
              ),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 20),
                child: Text(
                  "Then visit our website to register:",
                  style: Theme.of(context).textTheme.displaySmall,
                  textAlign: TextAlign.center,
                ),
              ),
              SizedBox(
                height: 20,
              ),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  minimumSize: Size(200, 50),
                  shape: StadiumBorder(),
                  primary: Theme.of(context).buttonColor,
                ),
                onPressed: launch_Url,
                child: SizedBox(
                  width: MediaQuery.of(context).size.width * 0.4,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    mainAxisSize: MainAxisSize.max,
                    children: [
                      Text(
                        "Register",
                        style: Theme.of(context).textTheme.titleSmall?.copyWith(
                              color: Colors.white,
                              fontSize: 20,
                            ),
                      ),
                      SizedBox(
                        width: 10,
                      ),
                      SizedBox(child: const Icon(Icons.open_in_new_rounded)),
                    ],
                  ),
                ),
              ),
              SizedBox(
                height: 20,
              ),
              SizedBox(
                width: MediaQuery.of(context).size.width * 0.8,
                child: Row(
                  children: [
                    Expanded(child: Divider()),
                    SizedBox(width: 5,),
                    Text(
                      "OR",
                      style: Theme.of(context)
                          .textTheme
                          .titleSmall
                          ?.copyWith(color: Theme.of(context).dividerColor),
                    ),
                    SizedBox(width: 5,),
                    Expanded(child: Divider()),
                  ],
                ),
              ),
              SizedBox(
                height: 20,
              ),
              OutlinedButton(
                onPressed: (() => moveToLastPage()),
                style: OutlinedButton.styleFrom(
                  minimumSize: Size(200, 50),
                  shape: StadiumBorder(),
                  primary: Theme.of(context).buttonColor,
                  side: BorderSide(
                      width: 2, color: Theme.of(context).buttonColor),
                ),
                child: SizedBox(
                  width: MediaQuery.of(context).size.width * 0.4,
                  child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          "Login",
                          style:
                              Theme.of(context).textTheme.titleSmall?.copyWith(
                                    color: Theme.of(context).primaryColor,
                                    fontSize: 20,
                                  ),
                        ),
                        SizedBox(
                          width: 10,
                        ),
                        Icon(Icons.arrow_forward,
                            color: Theme.of(context).primaryColor),
                      ]),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
