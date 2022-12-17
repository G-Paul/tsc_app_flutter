import 'package:flutter/material.dart';

class IntroPage1 extends StatelessWidget {
  const IntroPage1({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.only(top: 00, bottom: 20, right: 20, left: 20),
      color: Theme.of(context).backgroundColor,
      child: Center(
        child: SingleChildScrollView(
          child: Column(
            // mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              SizedBox(height: MediaQuery.of(context).size.height * 0.1),
              Container(
                height: MediaQuery.of(context).size.height * 0.25,
                width: double.infinity,
                child: Image.asset(
                    'assets/images/intro-screen/intro-trophy.png',
                    fit: BoxFit.contain),
              ),
              SizedBox(
                height: 30,
              ),
              Container(
                child: Text(
                  "What do we do?",
                  style: Theme.of(context).textTheme.displayLarge,
                ),
              ),
              SizedBox(
                height: 20,
              ),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 20),
                child: Text(
                  "Every student is different. We try to find the best in them and work passionately in order to awaken the inner potential and channelize it to an optimum level.",
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
