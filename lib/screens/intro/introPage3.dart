import 'package:flutter/material.dart';

class IntroPage3 extends StatelessWidget {
  const IntroPage3({super.key});

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
                child: Image.asset('assets/images/intro-screen/intro-test.png',
                    fit: BoxFit.contain),
              ),
              SizedBox(
                height: 30,
              ),
              Container(
                child: Text(
                  "How are we unique?",
                  style: Theme.of(context).textTheme.displayLarge,
                ),
              ),
              SizedBox(
                height: 30,
              ),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 20),
                child: Text(
                  "Individual attention and performance analysis are the key factors to our success. Of course, we have other secret ingredients as well!",
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
