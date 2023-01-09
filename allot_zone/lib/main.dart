import 'package:allot_zone/Colors.dart';
import 'package:allot_zone/room_select.dart';
import 'package:allot_zone/splashScreen.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

Future main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  
  runApp(const AllotZone());
}

class AllotZone extends StatelessWidget {
  const AllotZone({super.key});


  //Function that creates a Color swatch 
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
          primarySwatch: createMaterialColor(const Color.fromARGB(255, 255, 214, 10)),
          scaffoldBackgroundColor: const Color.fromARGB(255, 48, 48, 48),
          fontFamily: 'Monsterrat',
          textTheme: Theme.of(context).textTheme.apply(
            fontFamily: 'Monsterrat',
            bodyColor: MyColors.textColor,

          )
        ),
        home: Scaffold(
          body: RoomSelection(),
        ));
  }
}
