import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_nav_bar/google_nav_bar.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import './screens/home/home_screen.dart';
import './screens//main_screen.dart';
import './screens/login/login_button.dart';
import './app_themes.dart';
import './screens/intro/intro_screen.dart';

// void main() {
//   runApp(MyApp());
// }

Future main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();

  runApp(MyApp());
  // SystemChrome.setEnabledSystemUIOverlays([SystemUiOverlay.top]);
}

class MyApp extends StatelessWidget {
  MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'TSC_Mobile',
      theme: LightThemes.light_theme_1,
      darkTheme: DarkThemes.dark_theme_2,
      home: StreamBuilder<User?>(
        stream: FirebaseAuth.instance.authStateChanges(),
        builder: (context, snapshot) {
          if (snapshot.hasData)
            return MainScreen();
          else
            return IntroScreen();
        },
      ),
    );
  }
}
