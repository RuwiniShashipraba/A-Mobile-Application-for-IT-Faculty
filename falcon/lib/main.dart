import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:falcon/splashScreen.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        primarySwatch: MaterialColor(0xFF0b3140, color),
      ),
      debugShowCheckedModeBanner: false,
      home: SplashScreen(),
    );
  }
}

Map<int, Color> color = {
  50: Color.fromRGBO(51, 153, 255, .1),
  100: Color.fromRGBO(51, 153, 255, .2),
  200: Color.fromRGBO(51, 153, 255, .3),
  300: Color.fromRGBO(51, 153, 255, .4),
  400: Color.fromRGBO(51, 153, 255, .5),
  500: Color.fromRGBO(51, 153, 255, .6),
  600: Color.fromRGBO(51, 153, 255, .7),
  700: Color.fromRGBO(51, 153, 255, .8),
  800: Color.fromRGBO(51, 153, 255, .9),
  900: Color.fromRGBO(51, 153, 255, 1),
};
