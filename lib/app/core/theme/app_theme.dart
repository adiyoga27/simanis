part of 'theme.dart';

ThemeData appTheme = ThemeData(

  scaffoldBackgroundColor: const Color.fromARGB(255, 245, 245, 245),
  appBarTheme: AppBarTheme(
    centerTitle: false,
    backgroundColor: Utils.hex('018fe3'),
    surfaceTintColor: Colors.black87,
    elevation: .5,
    titleTextStyle: Gfont.fs20.copyWith(color: Colors.white),
    iconTheme: const IconThemeData(color: Colors.white, size: 20),
  ),
  iconTheme: const IconThemeData(color: Colors.black, size: 20),
  textTheme: TextTheme(
    bodyLarge: gfont,
    bodyMedium: gfont,
    titleMedium: gfont,
    titleSmall: gfont,
  ),
);
  

// Color primaryColor = Utils.hex('121212');
Color primaryColor = Utils.hex('018fe3');
Color secondaryColor = Utils.hex('f7f7f7');
