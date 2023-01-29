import 'package:flutter/material.dart';
import 'package:flutter_neumorphic/flutter_neumorphic.dart';
import 'package:flutter/services.dart';
import 'package:google_nav_bar/google_nav_bar.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '/screens/student/student_main.dart';
import './screens//main_screen.dart';
import './screens/intro/login_page.dart';
import './app_themes.dart';
import './screens/intro/intro_screen.dart';
import 'screens/student/models/student_performance.dart';
import './models/db/database.dart';
import 'package:flutter_downloader/flutter_downloader.dart';

// void main() {
//   runApp(MyApp());
// }

Future main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await FlutterDownloader.initialize(
    debug: true,
    ignoreSsl: true,
  );
  await Firebase.initializeApp();
  SharedPreferences prefs = await SharedPreferences.getInstance();
  final isLoggedIn = prefs.getBool('isLoggedIn') ?? false;
  final userType = prefs.getString('userType') ?? '';
  runApp(MyApp(isLoggedIn: isLoggedIn, userType: userType));
  // SystemChrome.setEnabledSystemUIOverlays([SystemUiOverlay.top]);
}

class MyApp extends StatelessWidget {
  final bool isLoggedIn;
  final String userType;
  MyApp({required this.isLoggedIn, required this.userType, super.key});

  @override
  Widget build(BuildContext context) {
    UserAuth userAuth = new UserAuth();
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'TSC_Mobile',
      theme: LightThemes.light_theme_1,
      darkTheme: DarkThemes.dark_theme_1,
      themeMode: ThemeMode.system,
      routes: {
        '/MainScreen': (context) => MainScreen(),
        '/IntroScreen': (context) => IntroScreen(),
        '/StudentMainScreen': (context) => StudentMainScreen(),
        // '/studentPerformance': (context) => StudentPerformace(),
      },
      home: (userAuth.isLoggedIn()) ? GetScreen(userType) : IntroScreen(),
    );
  }
}

Widget GetScreen(String userType) {
  switch (userType) {
    case 'admin':
      return MainScreen();
    case 'student':
      return StudentMainScreen();
    case 'teacher':
      return MainScreen();
    default:
      return IntroScreen();
  }
}
