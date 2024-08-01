part of 'theme.dart';

ThemeData appTheme = ThemeData(
  appBarTheme: AppBarTheme(
    centerTitle: false,
    backgroundColor: Colors.white,
    surfaceTintColor: Colors.black87,
    elevation: .5,
    titleTextStyle: Gfont.fs20,
    iconTheme: const IconThemeData(color: Colors.black87, size: 20),
  ),
  iconTheme: const IconThemeData(color: Colors.black87, size: 20),
  textTheme: TextTheme(
    bodyLarge: gfont,
    bodyMedium: gfont,
    titleMedium: gfont,
    titleSmall: gfont,
  ),
);

Color primaryColor = Utils.hex('121212');
Color secondaryColor = Utils.hex('f7f7f7');
