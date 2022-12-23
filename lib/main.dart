import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_nav_bar/google_nav_bar.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:shared_preferences/shared_preferences.dart';
import './screens/home/home_screen.dart';
import './screens//main_screen.dart';
import './screens/intro/login_page.dart';
import './app_themes.dart';
import './screens/intro/intro_screen.dart';
import './models/db/database.dart';

// void main() {
//   runApp(MyApp());
// }

Future main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  SharedPreferences prefs = await SharedPreferences.getInstance();
  runApp(MyApp(prefs));
  // SystemChrome.setEnabledSystemUIOverlays([SystemUiOverlay.top]);
}

class MyApp extends StatelessWidget {
  SharedPreferences prefs;
  MyApp(this.prefs, {super.key});

  @override
  Widget build(BuildContext context) {
    UserAuth userAuth = new UserAuth();
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'TSC_Mobile',
      theme: LightThemes.light_theme_1,
      darkTheme: DarkThemes.dark_theme_2,
      themeMode: ThemeMode.system,
      routes: {
        '/MainScreen': (context) => MainScreen(),
        '/IntroScreen': (context) => IntroScreen(),
      },
      home: (userAuth.isLoggedIn()) ? MainScreen() : IntroScreen(),
    );
  }
}
