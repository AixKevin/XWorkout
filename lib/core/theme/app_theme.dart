import 'package:flutter/cupertino.dart';

class AppTheme {
  static const Color primaryColor = Color(0xFF007AFF);
  static const Color scaffoldBackgroundColorLight = Color(0xFFF2F2F7);
  static const Color scaffoldBackgroundColorDark = Color(0xFF000000);
  static const Color activeColor = Color(0xFF34C759); 

  static CupertinoThemeData get lightTheme {
    return const CupertinoThemeData(
      brightness: Brightness.light,
      primaryColor: primaryColor,
      scaffoldBackgroundColor: scaffoldBackgroundColorLight,
      barBackgroundColor: Color(0xF0F9F9F9),
      textTheme: CupertinoTextThemeData(
        primaryColor: primaryColor,
      ),
    );
  }

  static CupertinoThemeData get darkTheme {
    return const CupertinoThemeData(
      brightness: Brightness.dark,
      primaryColor: primaryColor,
      scaffoldBackgroundColor: scaffoldBackgroundColorDark,
      barBackgroundColor: Color(0xF01D1D1D),
      textTheme: CupertinoTextThemeData(
        primaryColor: primaryColor,
      ),
    );
  }
}
