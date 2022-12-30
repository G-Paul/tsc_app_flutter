import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';

class LightThemes {
  static ThemeData light_theme_1 = ThemeData(
    primaryColor: Color(0xFF00BF6D),
    // backgroundColor: const Color(0xFFFDFDF5),
    backgroundColor: Colors.white,
    scaffoldBackgroundColor: Color(0xFFF7F7EE),
    buttonColor: Color(0xFF00BF6D),
    iconTheme: const IconThemeData(
      color: const Color.fromARGB(255, 46, 49, 42),
    ),
    dividerColor: Color(0x3400BF6C),
    focusColor: Colors.orange[800],
    bottomAppBarColor: const Color(0xFFFDFDF5),
    appBarTheme: const AppBarTheme(
      backgroundColor: Color(0xFFF7F7EE),
      elevation: 0,
      foregroundColor: const Color(0xFF1A1C18),
      systemOverlayStyle: SystemUiOverlayStyle(
        statusBarColor: Color(0xFFF7F7EE),
        statusBarIconBrightness: Brightness.dark,
        statusBarBrightness: Brightness.light,
      ),
    ),
    buttonTheme: const ButtonThemeData(
      buttonColor: Color(0xFF00BF6D),
    ),
    textTheme: TextTheme(
      bodySmall: GoogleFonts.raleway(
        textStyle: TextStyle(
          color: Color.fromARGB(255, 39, 39, 39),
          fontSize: 16,
        ),
      ),
      titleSmall: GoogleFonts.raleway(
        textStyle: TextStyle(
          color: Color(0xFF00BF6D),
          fontSize: 17,
          fontWeight: FontWeight.bold,
        ),
      ),
      labelSmall: GoogleFonts.raleway(
        textStyle: TextStyle(
          color: Color.fromARGB(81, 0, 0, 0),
          fontSize: 13,
        ),
      ),
      titleLarge: GoogleFonts.raleway(),
      displayLarge: GoogleFonts.raleway(
        textStyle: TextStyle(
          color: Color(0xFF00BF6D),
          fontSize: 30,
          fontWeight: FontWeight.w600,
        ),
      ),
      displaySmall: GoogleFonts.mukta(
          textStyle: TextStyle(
        color: Color.fromARGB(255, 102, 102, 102),
        fontSize: 20,
        // height: 28,
        fontWeight: FontWeight.normal,
      )),
      // button: GoogleFonts.raleway(
      //     // fontWeight: FontWeight.bold,
      //     ),
    ),
  );
}

class DarkThemes {
  static ThemeData dark_theme_1 = ThemeData(
    primaryColor: Color(0xFF00BF6D),
    backgroundColor: Color(0xFF151331),
    scaffoldBackgroundColor: Color(0xFF100F25),
    buttonColor: Color(0xFF00BF6D),
    focusColor: Colors.orange[400],
    iconTheme: const IconThemeData(
      color: Color(0xFF00BF6D),
    ),
    bottomAppBarColor: const Color(0xFFEDF2E2),
    appBarTheme: const AppBarTheme(
      backgroundColor: Color(0xFF100F25),
      elevation: 0,
      foregroundColor: Color(0xFF00BF6D),
      systemOverlayStyle: SystemUiOverlayStyle(
        statusBarColor: Color(0xFF100F25),
        statusBarIconBrightness: Brightness.light,
        statusBarBrightness: Brightness.dark,
      ),
    ),
    buttonTheme: ButtonThemeData(
      buttonColor: Color(0xFF00BF6D),
    ),
    textTheme: TextTheme(
      bodySmall: GoogleFonts.raleway(
        textStyle: TextStyle(
          color: Color(0xFFFFFFFF),
          fontSize: 15,
        ),
      ),

      titleSmall: GoogleFonts.raleway(
        textStyle: TextStyle(
          color: Color(0xFF00BF6D),
          fontWeight: FontWeight.bold,
          fontSize: 15,
        ),
      ),
      labelSmall: GoogleFonts.raleway(
        textStyle: TextStyle(
          // color: Color(0xFF00BF6D),
          color: Color(0xB0FFFEFE),
          fontSize: 13,
        ),
      ),
      titleLarge: GoogleFonts.raleway(
        color: Colors.white,
      ),
      displayLarge: GoogleFonts.raleway(
        textStyle: TextStyle(
          color: Color(0xFF00BF6D),
          fontSize: 30,
          fontWeight: FontWeight.w600,
        ),
      ),
      displaySmall: GoogleFonts.mukta(
        textStyle: TextStyle(
          color: Color.fromARGB(201, 255, 254, 254),
          fontSize: 20,
          // height: 28,
          fontWeight: FontWeight.normal,
        ),
      ),
      // button: GoogleFonts.raleway(
      //   fontWeight: FontWeight.bold,
      // ),
    ),
    drawerTheme: DrawerThemeData(
      backgroundColor: Color(0xFF181736),
    ),
    dividerColor: Color(0x3400BF6C),
  );

  // static ThemeData dark_theme_1 = ThemeData(
  //   primaryColor: Color(0xFF00BF6D),
  //   backgroundColor: Color(0xFF100F25),
  //   scaffoldBackgroundColor: Color(0xFF100F25),
  //   buttonColor: Color(0xFF00BF6D),
  //   focusColor: const Color(0xFFFDFDF5),
  //   iconTheme: const IconThemeData(
  //     color: Color(0xFF00BF6D),
  //   ),
  //   bottomAppBarColor: const Color(0xFFEDF2E2),
  //   appBarTheme: const AppBarTheme(
  //     backgroundColor: Color(0xFF00BF6D),
  //     elevation: 0,
  //     foregroundColor: const Color(0xFF1A1C18),
  //   ),
  //   buttonTheme: const ButtonThemeData(
  //     buttonColor: Color(0xFF00BF6D),
  //   ),
  //   textTheme: TextTheme(
  //     bodySmall: TextStyle(
  //       color: Color(0xFFFFFFFF),
  //     ),
  //     titleSmall: TextStyle(
  //       color: Color(0xFF00BF6D),
  //       fontSize: 5,
  //     ),
  //   ),
  //   drawerTheme: DrawerThemeData(
  //     backgroundColor: Color(0xFF181736),
  //   ),
  //   dividerColor: Color(0x2C00BF6C),
  // );
}
