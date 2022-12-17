import 'package:flutter/material.dart';

class IntroPage2 extends StatelessWidget {
  const IntroPage2({super.key});

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
                width: double.infinity,
                child: Image.asset('assets/images/intro-screen/intro-class.png',
                    fit: BoxFit.contain),
              ),
              SizedBox(
                height: 30,
              ),
              Container(
                child: Text(
                  "How do we do it?",
                  style: Theme.of(context).textTheme.displayLarge,
                ),
              ),
              SizedBox(
                height: 30,
              ),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 20),
                child: Text(
                  "Well, everyone is blessed with unique skills. We figure out the capabilities of each individual and combine them to work in conjunction.",
                  style: Theme.of(context).textTheme.displaySmall,
                  textAlign: TextAlign.center,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
