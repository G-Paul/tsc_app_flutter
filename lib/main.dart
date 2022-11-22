import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_nav_bar/google_nav_bar.dart';
import 'package:firebase_core/firebase_core.dart';

import './screens/home/home_screen.dart';
import './screens//main_screen.dart';
import './screens/login/login_button.dart';
import './app_themes.dart';

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

  // var theme_1 = ThemeData(
  //   primaryColor: Color(0xFF93F041),
  //   backgroundColor: const Color(0xFFFDFDF5),
  //   buttonColor: Color.fromARGB(255, 189, 255, 132),
  //   iconTheme: const IconThemeData(
  //     color: const Color.fromARGB(255, 46, 49, 42),
  //   ),
  //   bottomAppBarColor: const Color(0xFFEDF2E2),
  //   appBarTheme: const AppBarTheme(
  //     backgroundColor: const Color(0xFFFDFDF5),
  //     elevation: 0,
  //     foregroundColor: const Color(0xFF1A1C18),
  //   ),
  //   buttonTheme: const ButtonThemeData(
  //     buttonColor: Color.fromARGB(255, 205, 244, 122),
  //   ),
  //   textTheme: TextTheme(),
  // );
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'TSC_Mobile',
      // theme: LightThemes.light_theme_1,
      theme: LightThemes.light_theme_1,
      darkTheme: DarkThemes.dark_theme_2,
      home: MainScreen(),
    );
  }
}
