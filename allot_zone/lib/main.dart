import 'package:allot_zone/splashScreen.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(const AllotZone());
}

class AllotZone extends StatelessWidget {
  const AllotZone({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        theme: ThemeData(
          primarySwatch: Colors.grey,
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
