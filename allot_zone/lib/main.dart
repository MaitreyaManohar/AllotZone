import 'package:allot_zone/splashScreen.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(const AllotZone());
}

class AllotZone extends StatelessWidget {
  const AllotZone({super.key});

  MaterialColor createMaterialColor(Color color) {
  List strengths = <double>[.05];
  Map<int, Color> swatch = {};
  final int r = color.red, g = color.green, b = color.blue;

  for (int i = 1; i < 10; i++) {
    strengths.add(0.1 * i);
  }
  for (var strength in strengths) {
    final double ds = 0.5 - strength;
    swatch[(strength * 1000).round()] = Color.fromRGBO(
      r + ((ds < 0 ? r : (255 - r)) * ds).round(),
      g + ((ds < 0 ? g : (255 - g)) * ds).round(),
      b + ((ds < 0 ? b : (255 - b)) * ds).round(),
      1,
    );
  }
  return MaterialColor(color.value, swatch);
}

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        theme: ThemeData(
          primarySwatch: createMaterialColor(Color.fromARGB(255, 255, 214, 10)),
          scaffoldBackgroundColor: const Color.fromARGB(255, 48, 48, 48),
          fontFamily: 'Nexa',
          textTheme: TextTheme(
            button: TextStyle(color: Colors.amber),
            // labelMedium: TextStyle(color: Colors.amber),
            
            // displayMedium: TextStyle(color: Colors.amber),
            subtitle1: TextStyle(color: Theme.of(context).primaryColorLight),
          ),
        ),
        home: const Scaffold(
          body: SplashScreen(),
        ));
  }
}
